#!/usr/bin/awk -f

BEGIN {
	T = 2503; # time we're interested in
}

/[A-Z][a-z]+ can fly [0-9]+ km\/s for [0-9]+ seconds?, but then must rest for [0-9]+ seconds?\./ {
	reindeer              = $1;
	speed[reindeer]       = int($4);
	flying_sec[reindeer]  = int($7);
	resting_sec[reindeer] = int($14);
	is_flying[reindeer]   = 1;
	time_left[reindeer]   = flying_sec[reindeer];
	distance[reindeer]    = 0;
	score[reindeer]       = 0;
}

END {
	for (second = 1; second <= T; second++) {
		for (reindeer in speed)
			fly_or_rest(reindeer);
		# compute the leader(s) distance for this second.
		for (reindeer in speed)
			d = distance[reindeer] > d ? distance[reindeer] : d;
		# update the scores accordingly.
		for (reindeer in speed) {
			if (distance[reindeer] == d)
				score[reindeer]++;
		}
	}

	# find the best score
	for (reindeer in speed)
		s = score[reindeer] > s ? score[reindeer] : s;

	print s;
}

function fly_or_rest(reindeer,    cycle_sec, cycle_distance, ncycle) {
	distance[reindeer] += is_flying[reindeer] * speed[reindeer];
	if (--time_left[reindeer] == 0) {
		is_flying[reindeer] = !is_flying[reindeer];
		time_left[reindeer] = (is_flying[reindeer] ? flying_sec[reindeer] : resting_sec[reindeer]);
	}
}
