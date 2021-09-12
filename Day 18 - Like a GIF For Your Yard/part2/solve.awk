#!/usr/bin/awk -f

BEGIN {
	# split the input into one field per character.
	FS = "";
	STEPS = 100;
}

{
	for (i = 1; i <= NF; i++)
		grid[i, NR] = ($i == "#");
}

END {
	# do animation steps by batch of two, because we use two arrays to
	# ping-pong the light states.
	for (i = 2; i <= STEPS; i += 2) {
		animate(grid, grid0, NR);
		animate(grid0, grid, NR);
	}

	if (STEPS % 2 == 0) {
		nlit = sum(grid);
	} else {
		# the number of steps is odd, we're off-by-one animation run.
		animate(grid, grid0, NR);
		nlit = sum(grid0);
	}
	print nlit;
}

function animate(from, to, len,    x, ystart, ystop, y, n) {
	# corners
	to[1, 1] = to[1, len] = to[len, 1] = to[len, len] = 1;
	for (x = 1; x <= len; x++) {
		ystart = 1   + (x == 1 || x == len);
		ystop  = len - (x == 1 || x == len);
		for (y = ystart; y <= ystop; y++) {
			n = from[x - 1, y - 1] + \
			    from[x    , y - 1] + \
			    from[x + 1, y - 1] + \
			    from[x + 1, y    ] + \
			    from[x + 1, y + 1] + \
			    from[x    , y + 1] + \
			    from[x - 1, y + 1] + \
			    from[x - 1, y    ];
			to[x, y] = (n == 3 || n == 2 && from[x, y]);
		}
	}
	# corners
	to[1, 1] = to[1, len] = to[len, 1] = to[len, len] = 1;
}

function sum(from,    i, n) {
	for (i in from)
		n += from[i];
	return n;
}
