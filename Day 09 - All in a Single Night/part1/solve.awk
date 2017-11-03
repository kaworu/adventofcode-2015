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
	      city, c, next_to_visit, l, min_len) {
	if (to_visit_len == 0)
		return len;

	for (city in to_visit) {
		delete next_to_visit;
		for (c in to_visit) {
			if (c != city)
				next_to_visit[c] = 1;
		}
		if (!previous)
			l = tsp(next_to_visit, to_visit_len - 1, city);
		else
			l = tsp(next_to_visit, to_visit_len - 1, city, len + distances[previous, city]);
		min_len = (!min_len || l < min_len ? l : min_len);
	}
	return min_len;
}
