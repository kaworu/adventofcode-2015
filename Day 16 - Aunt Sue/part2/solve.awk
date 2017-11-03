#!/usr/bin/awk -f

BEGIN {
	reading["children"]    = "= 3";
	reading["cats"]        = "> 7";
	reading["samoyeds"]    = "= 2";
	reading["pomeranians"] = "< 3";
	reading["akitas"]      = "= 0";
	reading["vizslas"]     = "= 0";
	reading["goldfish"]    = "< 5";
	reading["trees"]       = "> 3";
	reading["cars"]        = "= 2";
	reading["perfumes"]    = "= 1";
}

/Sue [0-9]+: [a-z]+: [0-9]+, [a-z]+: [0-9]+, [a-z]+: [0-9]+/ {
	id = int($2);
	for (i = 3; i <= 7; i += 2) {
		key = $i;
		sub(/:$/, "", key); # remove the trailing `:'
		val = int($(i + 1));
		split(reading[key], cmp);
		if (!eval(val, cmp[1], int(cmp[2])))
			next;
	}

	print id;
}

function eval(lhs, op, rhs) {
	return (op == "=" && lhs == rhs ||
		op == "<" && lhs  < rhs ||
		op == ">" && lhs  > rhs);
}
