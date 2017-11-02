#!/usr/bin/awk -f

BEGIN {
	T = 2503; # time we're interested in
}

/[A-Z][a-z]+ can fly [0-9]+ km\/s for [0-9]+ seconds?, but then must rest for [0-9]+ seconds?\./ {
	reindeer              = $1;
	speed[reindeer]       = int($4);
	flying_sec[reindeer]  = int($7);
	resting_sec[reindeer] = int($14);
}

END {
	# we can compute the travel distance independently for each Reindeer.
	for (reindeer in speed) {
		d = distance(reindeer, T);
		winner = (d > winner ? d : winner);
	}
	print winner;
}

function distance(reindeer, time,    cycle_sec, cycle_distance, ncycle) {
	# a cycle is the time needed for the reindeer to fly and rest fully.
	cycle_sec = flying_sec[reindeer] + resting_sec[reindeer];
	# the travel distance of the reindeer during a cycle.
	cycle_distance = speed[reindeer] * flying_sec[reindeer];
	# the number of cycle the reindeer can do in the given time.
	ncycle = int(time / cycle_sec);
	# the number of seconds that is left after the reindeer has performed
	# ncycle.
	partial = time % cycle_sec;
	if (partial >= flying_sec[reindeer])
		return cycle_distance * ncycle + cycle_distance;
	else
		return cycle_distance * ncycle + speed[reindeer] * partial;
}
