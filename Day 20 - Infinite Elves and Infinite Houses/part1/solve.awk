#!/usr/bin/awk -f

{
	# Each elf delivers 10 presents.
	puzzle = int($0) / 10;
}

END {
	# find the a lower bound using a binary search and Robin's theorem.
	min = 1;
	max = puzzle;
	while (min < max) {
		mid = min + int((max - min) / 2);
		if (mid < 3) {
			# NOTE: Robin's theorem only works for n <= 3. If we
			# land here though puzzle is really small.
			break;
		}
		if (robin(mid) > puzzle)
			max = mid;
		else
			min = mid + 1;
	}

	# search linearily starting from min.
	while (sigma(min) < puzzle)
		min += 1;
	print min;
}

# see https://en.wikipedia.org/wiki/Divisor_function
# returns x where x > σ(n), n >= 3
# We use Robin's theorem unconditional inequality.
function robin(n,    e, lln) {
	# see https://en.wikipedia.org/wiki/Euler%E2%80%93Mascheroni_constant
	e = 0.57721566490153286060651209008240243104215933593992;
	lln = log(log(n));
	return exp(e) * n * lln + 0.6483 * n / lln;
}

# implement the `S(n)' and `S(p^k)' functions from
# https://www.math.upenn.edu/~deturck/m170/wk3/lecture/sumdiv.html`
function sigma(p, k,   powers, base) {
	if ((p, k) in _sigma) {
		# memoized, do nada.
	} else if (k) {
		_sigma[p, k] = (p ^ (k + 1) - 1) / (p - 1);
	} else {
		factorize(p, powers);
		_sigma[p, k] = 1;
		for (base in powers)
			_sigma[p, k] *= sigma(base, powers[base]);
	}
	return _sigma[p, k];
}

# "naive" prime factorization of n. `powers' will contains bases keys and
# exponents as values.
function factorize(n, powers,    p) {
	sieve(int(sqrt(n)) + 1);
	for (p in primes) {
		while (n % p == 0) {
			n /= p;
			powers[p] += 1;
		}
		if (n == 1)
			break;
	}
	if (n > 1)
		powers[n] += 1;
}

# fill the primes array with prime numbers up to `until'.
# see https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
function sieve(until,    i, sq, x) {
	if (!_primes_last_until) { # bootstrap
		primes[2] = 1; _primes_last_mul[2] =  8;
		primes[3] = 1; _primes_last_mul[3] =  9;
		primes[5] = 1; _primes_last_mul[5] = 10;
		primes[7] = 1; _primes_last_mul[7] =  7;
		_primes_last_until = 10;
	}
	if (until <= _primes_last_until)
		return; # already previously computed

	# mark all unknown numbers as prime.
	for (i = _primes_last_until + 1; i <= until; i++)
		primes[i] = 1;
	# we only need to go until the square root of `until', because it can
	# not have a pair of divisors both greater than `sqrt(until)' by
	# definition.
	sq = sqrt(until) + 1; # NOTE: + 1 to round up.
	for (i = 2; i <= sq; i++) {
		if (i in primes) {
			x = _primes_last_mul[i];
			while ((x += i) <= until)
				delete primes[x];
			_primes_last_mul[i] = x - i;
		}
	}
	_primes_last_until = until;
}
