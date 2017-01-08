#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
}

{
	for (i = 1; i <= NF; i++) {
		if ($i == "(")
			floor++;
		else if ($i == ")")
			floor--;
	}
}

END {
	print floor;
}
