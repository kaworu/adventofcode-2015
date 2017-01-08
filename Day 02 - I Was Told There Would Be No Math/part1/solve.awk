#!/usr/bin/awk -f

BEGIN {
	# input lines are like "1x2x3"
	FS = "x";
}

{
	l = $1; w = $2; h = $3;
	# compute the 6 surfaces of the box
	sides["top"]  = l * w; sides["bottom"] = sides["top"];
	sides["left"] = w * h; sides["right"]  = sides["left"];
	sides["back"] = h * l; sides["front"]  = sides["back"];
	# required wrapping paper (sum of all the surfaces)
	for (s in sides)
		paper += sides[s];
	# little extra (smallest side)
	paper += min3(sides["top"], sides["left"], sides["back"]);
}

END {
	print paper;
}

function min3(a, b, c) {
	return (a < b ? (a < c ? a : c) : (b < c ? b : c));
}
