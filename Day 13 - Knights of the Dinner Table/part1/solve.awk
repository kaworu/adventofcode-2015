#!/usr/bin/awk -f

/[A-Z][a-z]+ would (gain|lose) [0-9]+ happiness units by sitting next to [A-Z][a-z]+\./ {
	subject = $1;
	happy   = ($3 == "gain");
	units   = int($4) * (happy ? 1 : -1);
	next_to = $11;
	sub(/\.$/, "", next_to);
	happiness[subject, next_to] += units;
	happiness[next_to, subject] += units;
	people[subject] = people[next_to] = 1;
}

END {
	for (person in people) {
		npeople++;
	}

	print happiest(people, npeople);
}

function happiest(standing, nstanding, first, previous, change,
	      person, c, max_change) {
	if (nstanding == 0)
		return change + happiness[first, previous];

	for (person in standing) {
		delete standing[person];
		if (!first) {
			# unlike TSP we don't have to try every permutations,
			# we can start with any person. We could optimize
			# further though, because
			#     <- A <-> B <-> C <-> D ->
			# will yield the same result as
			#     <- A <-> D <-> C <-> B ->
			return happiest(standing, nstanding - 1, person, person);
		}
		c = happiest(standing, nstanding - 1, first, person, change + happiness[previous, person]);
		standing[person] = 1;
		max_change = (c > max_change ? c : max_change);
	}
	return max_change;
}
