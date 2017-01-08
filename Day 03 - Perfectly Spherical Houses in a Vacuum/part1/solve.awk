#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
	# Santa's position on the grid
	x = 0; y = 0;
	# Santa begins by delivering a present to the house at his starting
	# location
	deliver_at(x, y);
}

{
	for (i = 1; i <= NF; i++) {
		if ($i == "^")
			y++;
		if ($i == "v")
			y--;
		if ($i == ">")
			x++;
		if ($i == "<")
			x--;
		deliver_at(x, y);
	}
}

END {
	print houses_delivered;
}

function deliver_at(x, y) {
	if (presents_at[x, y] == 0)
		houses_delivered += 1;
	presents_at[x, y] += 1;
}
