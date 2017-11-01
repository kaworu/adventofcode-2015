#!/usr/bin/awk -f

/(toggle|turn on|turn off) [0-9]+,[0-9]+ through [0-9]+,[0-9]+/ {
	if ($1 == "toggle") {
		square($2, $4);
		delta = +2;
	} else { # $1 == turn
		square($3, $5);
		delta = ($2 == "on" ? +1 : -1);
	}
	for (x = tlx; x <= brx; x++) {
		for (y = tly; y <= bry; y++) {
			grid[x, y] += delta;
			# don't go below 0 brightness
			if (grid[x, y] < 0)
				grid[x, y] = 0;
		}
	}
}

END {
	for (light in grid)
		brightness += grid[light];
	print brightness;
}

function square(from, to,    light) {
	split(from, light, /,/);
	tlx = int(light[1]); # top-left x
	tly = int(light[2]); # top-left y
	split(to, light, /,/);
	brx = int(light[1]); # bottom-right x
	bry = int(light[2]); # bottom-right y
}
