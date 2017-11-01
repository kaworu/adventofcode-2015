#!/usr/bin/awk -f

/turn (on|off) [0-9]+,[0-9]+ through [0-9]+,[0-9]+/ {
	state = ($2 == "on" ? 1 : 0);
	square($3, $5);
	for (x = tlx; x <= brx; x++) {
		for (y = tly; y <= bry; y++) {
			grid[x, y] = state;
		}
	}
}

/toggle [0-9]+,[0-9]+ through [0-9]+,[0-9]+/ {
	square($2, $4);
	for (x = tlx; x <= brx; x++) {
		for (y = tly; y <= bry; y++) {
			grid[x, y] = !grid[x, y];
		}
	}
}

END {
	for (light in grid)
		count += grid[light];
	print count;
}

function square(from, to,    light) {
	split(from, light, /,/);
	tlx = int(light[1]); # top-left x
	tly = int(light[2]); # top-left y
	split(to, light, /,/);
	brx = int(light[1]); # bottom-right x
	bry = int(light[2]); # bottom-right y
}
