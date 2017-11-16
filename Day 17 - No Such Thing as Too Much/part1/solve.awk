#!/usr/bin/awk -f

/[0-9]+/ {
	c = int($1);
	# insert c into containers maintaining a descending order.
	for (i = NR - 1; i > 0 && containers[i] < c; i--)
		containers[i + 1] = containers[i];
	containers[i + 1] = c;
}

END {
	print fill(150);
}

function fill(liters, i,    l, count) {
	while (++i <= NR) {
		l = liters - containers[i];
		if (l == 0)
			count++;
		else if (l > 0)
			count += fill(l, i);
	}
	return count;
}
