#!/usr/bin/awk -f

{
	delete pairs;
	nrepeat = 0;
	nchars = split($0, chars, "");
	for (i = 1; i <= nchars; i++) {
		prev2 = (i < 3 ? 0 : chars[i - 2]);
		prev  = (i < 2 ? 0 : chars[i - 1]);
		c = chars[i];
		# save (prev, c) into our pairs array for later.
		if (prev)
			pairs[prev c]++;
		# "repeat" rule
		if (prev2)
			nrepeat += (c == prev2);
	}
	# the "contains without overlapping" rule is costly to compute, do it
	# only if we satistfy the "repeat" rule.
	if (!nrepeat)
		next;
	for (pair in pairs) {
		if (split($0, _, pair) > 2) {
			nice++;
			next;
		}
	}
}

END {
	print nice;
}
