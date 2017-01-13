#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
}

{
	total += length;
	# loop from the second character to the (last - 1), skipping both the
	# leading and trailing "
	for (i = 2; i < NF; i++) {
		if ($i == "\\") {
			i++; # skip the escaping backslash
			if ($i == "x") {
				# skip "x" and the first hexadecimal character.
				i += 2;
			}
		}
		unescaped++;
	}
}

END {
	print total - unescaped;
}
