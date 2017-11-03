#!/usr/bin/awk -f

/[0-9]+/ {
	c = int($1);
	# insert c into containers maintaining a descending order.
	for (i = ncontainers++; i > 0 && containers[i] < c; i--)
		containers[i + 1] = containers[i];
	containers[i + 1] = c;
}

END {
	solution["nused"] = ncontainers + 1;
	fill(150);
	print solution["count"];
}

function fill(liters, i, nused,    l) {
	while (++i <= ncontainers) {
		l = liters - containers[i];
		if (nused + 1 == solution["nused"]) {
			solution["count"] += (l == 0);
		} else if (nused + 1 < solution["nused"]) {
			if (l == 0) {
				solution["nused"] = nused + 1;
				solution["count"] = 1;
			} else if (l > 0) {
				fill(l, i, nused + 1);
			}
		}
	}
}
