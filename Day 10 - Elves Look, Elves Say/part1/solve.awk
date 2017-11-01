#!/usr/bin/awk -f

{
	puzzle = $0;
}

END {
	for (i = 1; i <= 40; i++)
		puzzle = look_and_say(puzzle);

	print length(puzzle);
}

function look_and_say(prev,    nchars, chars, c, n, seq, i) {
	nchars = split(prev, chars, "");
	c = chars[1];
	n = 1;
	for (i = 2; i <= nchars; i++) {
		if (chars[i] == c) {
			n++;
		} else {
			seq = sprintf("%s%d%s", seq, n, c);
			c = chars[i];
			n = 1;
		}
	}
	return sprintf("%s%d%s", seq, n, c);
}
