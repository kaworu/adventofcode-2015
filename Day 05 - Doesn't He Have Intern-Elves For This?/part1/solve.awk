#!/usr/bin/awk -f

{
	nvowels = ntwice = 0;
	nchars = split($0, chars, "");
	for (i = 1; i <= nchars; i++) {
		prev = (i == 1 ? 0 : chars[i - 1]);
		c = chars[i];
		# "vowels" rule check.
		nvowels += (c ~ /[aeiou]/);
		# "twice" and "exclusion" rules are on two characters, so we
		# only check them if we're past the first.
		if (prev) {
			ntwice += (c == prev);
			if ((prev c) ~ /ab|cd|pq|xy/)
				next;
		}
	}
	nice += (nvowels >= 3 && ntwice);
}

END {
	print nice;
}
