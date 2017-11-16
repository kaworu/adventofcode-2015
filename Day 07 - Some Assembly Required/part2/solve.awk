#!/usr/bin/awk -f

BEGIN {
	_bitwise_init();
}

# NOTE: we want to "normalize" all the parsed line as binary operation so that
# evaluation is easier to implement, so assignation and bitwise complement are
# actually rewritten in an equivalent binary operation.

# assign
/^([a-z]+|[0-9]+) -> [a-z]+$/ {
	src  = $1;
	dest = $3;
	# x & 0xffff == x
	operation[dest]  = "AND" FS src FS 65535; # 0xffff
}

# unary op
/^NOT ([a-z]+|[0-9]+) -> [a-z]+$/ {
	src  = $2;
	dest = $4;
	# x ^ 0xffff == ~x
	operation[dest]  = "XOR" FS src FS 65535; # 0xffff
}

# binary op
/^([a-z]+|[0-9]+) (AND|OR|LSHIFT|RSHIFT) ([a-z]+|[0-9]+) -> [a-z]+$/ {
	lhs  = $1;
	op   = $2;
	rhs  = $3;
	dest = $5;
	operation[dest]  = op FS lhs FS rhs;
}

END {
	a = solve("a");
	# reset the signals,
	delete signal;
	# set the signal b to previously computed a,
	signal["b"] = a;
	# and solve again.
	print solve("a");
}

function solve(x,    expr, rhs, lhs) {
	if (x ~ /[0-9]+/)
		return int(x);
	# if we already know the signal for x we don't need to compute it.
	if (signal[x])
		return signal[x];
	split(operation[x], expr);
	# expr is now like ["AND", "42", "y"]
	lhs = solve(expr[2]);
	rhs = solve(expr[3]);
	return signal[x] = eval(lhs, expr[1], rhs);
}

# actually evaluate the result of the operator op applied to lhs and rhs.
function eval(lhs, op, rhs) {
	if (op == "AND")
		return bw_and(lhs, rhs);
	else if (op == "OR")
		return bw_or(lhs, rhs);
	else if (op == "XOR")
		return bw_xor(lhs, rhs);
	else if (op == "LSHIFT")
		return bw_lshift(lhs, rhs) % (2 ^ 16);
	else if (op == "RSHIFT")
		return bw_rshift(lhs, rhs);
}

function bw_rshift(x, n) {
	return int(x / (2 ^ n));
}

function bw_lshift(x, n) {
	return x * (2 ^ n);
}

function bw_and(x, y,    i, r) {
	for (i = 0; i < 16; i += 4) {
		r = r / (2 ^ 4) + bw_lookup["and", x % 16, y % 16] * (2 ^ 12);
		x = int(x / (2 ^ 4));
		y = int(y / (2 ^ 4));
	}
	return r;
}

function bw_or(x, y,    i, r) {
	for (i = 0; i < 16; i += 4) {
		r = r / (2 ^ 4) + bw_lookup["or", x % 16, y % 16] * (2 ^ 12);
		x = int(x / (2 ^ 4));
		y = int(y / (2 ^ 4));
	}
	return r;
}

function bw_xor(x, y) {
	return (x + y - 2 * bw_and(x, y));
}

function _bitwise_init(    a, b, x, y, i) {
	# generate the bw_lookup table used by bw_and() and bw_or().
	for (a = 0; a < 16; a++) {
		for (b = 0; b < 16; b++) {
			x = a;
			y = b;
			for (i = 0; i < 4; i++) {
				bw_lookup["and", a, b] += ((x % 2) && (y % 2)) * (2 ^ i);
				bw_lookup["or",  a, b] += ((x % 2) || (y % 2)) * (2 ^ i);
				x = int(x / 2);
				y = int(y / 2);
			}
		}
	}
}
