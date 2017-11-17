#!/usr/bin/awk -f

BEGIN {
	FIRST      = 20151125;
	MULTIPLIER = 252533;
	DIVISOR    = 33554393;
}

/To continue, please consult the code grid in the manual\.  Enter the code at row [0-9]+, column [0-9]+\./ {
	row = int($16);
	col = int($18);
}

END {
	# If we "walk" starting from the top-left corner to our target number,
	# each step move us to the next diagonal regardless of the direction
	# (i.e. increasing our column or our row).
	d = row + col - 1;

	# Intuitively, our position is S(d - 1) + col where S(x) is the sum
	# from 1 to x. See
	# https://en.wikipedia.org/wiki/1_%2B_2_%2B_3_%2B_4_%2B_%E2%8B%AF
	pos = (d - 1) * d / 2 + col;

	# the power of MULTIPLIER is 0 at position 1, so offset by -1.
	n = pos - 1;

	print (FIRST * pow(MULTIPLIER, n, DIVISOR)) % DIVISOR;
}

# Compute (x ^ n) % m
# inspired by https://www.quora.com/What-are-some-fast-algorithms-for-computing-the-nth-power-of-a-number
function pow(x, n, m,    res) {
	res = 1;
	while (n > 0) {
		if (n % 2)
			res = (res * x) % m;
		x = (x * x) % m;
		n = int(n / 2);
	}
	return res;
}
