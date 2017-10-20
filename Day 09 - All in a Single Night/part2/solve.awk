#!/usr/bin/awk -f

/[a-zA-z]+ to [a-zA-z]+ = [0-9]+/ {
	from = $1;
	to   = $3;
	dist = $5;
	unvisited[from] = unvisited[to] = 1;
	distances[from, to] = distances[to, from] = int(dist);
}

END {
	for (city in unvisited)
		ncities++;

	for (start in unvisited) {
		for (city in unvisited)
			unvisited[city] = (city != start);
		walk(start, 0, start, unvisited, ncities - 1);
	}

	longest = 0;
	for (path in distances) {
		nhops = split(path, _, SUBSEP);
		if (nhops != ncities)
			continue;
		if (!longest || distances[path] > distances[longest])
			longest = path;
	}

	printf("%d\n", distances[longest]);
}

function walk(path, len, hop, unvisited, nunvisited,
	      next_city, next_path, next_len, c, next_unvisited)
{
	if (nunvisited == 0)
		return;

	for (next_city in unvisited) {
		if (!unvisited[next_city])
			continue;
		next_path = path SUBSEP next_city;
		next_len = distances[next_path] = len + distances[hop, next_city];
		# build next_unvisited by conceptually "pop"ing next_city from
		# unvisited
		for (c in unvisited)
			next_unvisited[c] = (c == next_city ? 0 : unvisited[c]);
		walk(next_path, next_len, next_city, next_unvisited, nunvisited - 1);
	}
}
