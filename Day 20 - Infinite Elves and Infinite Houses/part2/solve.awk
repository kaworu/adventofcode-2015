#!/usr/bin/awk -f

{
	puzzle = int($0);
}

END {
	max = puzzle / 11;
	for (i = 1; i <= max; i++) {
		for (j = i; j / i <= 50 && j <= max; j += i)
			houses[j] += 11 * i;
	}
	for (h = 0; houses[h] < puzzle; h++);
	print h;
}
