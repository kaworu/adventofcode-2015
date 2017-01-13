#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
}

{
	total += length;
	for (i = 1; i <= NF; i++) {
		if ($i == "\\" || $i == "\"")
			escaped++;
		escaped++;
	}
	escaped += 2; # account for both the leading and trailing quotes.
}

END {
	print escaped - total;
}
