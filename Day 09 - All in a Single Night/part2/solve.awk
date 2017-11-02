#!/usr/bin/awk -f

/[A-Za-z]+ to [A-Za-z]+ = [0-9]+/ {
	from = $1;
	to   = $3;
	dist = $5;
	to_visit[from] = to_visit[to] = 1;
	distances[from, to] = distances[to, from] = int(dist);
}

END {
	for (_ in to_visit)
		ncities++;
	print tsp(to_visit, ncities);
}

function tsp(to_visit, to_visit_len, previous, len,
	      city, l, max_len) {
	max_len = len;
	for (city in to_visit) {
		delete to_visit[city];
		if (!previous)
			l = tsp(to_visit, to_visit_len - 1, city);
		else
			l = tsp(to_visit, to_visit_len - 1, city, len + distances[previous, city]);
		to_visit[city] = 1;
		max_len = (l > max_len ? l : max_len);
	}
	return max_len;
}
