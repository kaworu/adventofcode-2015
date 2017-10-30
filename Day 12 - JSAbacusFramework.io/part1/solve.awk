#!/usr/bin/awk -f

BEGIN {
	FS = "[^0-9-]*";
}

{
	for (i = 1; i <= NF; i++)
		sum += int($i);
}

END {
	print sum;
}
