#!/usr/bin/awk -f

/[A-Za-z]+ => [A-Za-z]+/ {
	atoms[$1] = 1;
}

/^[A-Za-z]+$/ {
	molecule = $1;
}

END {
	# build a regular expression matching any atom.
	for (a in atoms)
		re = (re ? re "|" a : a);
	re = "(" re ")";

	# from a bit of spoil from
	# https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/cy4etju/
	# and analysis from
	# sed -e 's/Rn/(/g;s/Y/,/g;s/Ar/)/g;s/N/a/g;s/O/b/g;s/B/c/g;s/P/d/g;s/Al/n/g;s/F/f/g;s/Th/g/g;s/Si/h/g;s/Ti/i/g;s/H/j/g;s/Ca/k/g;s/Mg/m/g;' input.txt
	# we infer that we only have three production rules. Reduce them until
	# we're left with only one molecule. Replace any production by "e"
	# arbitrarily.
	fxx = re "Rn" re "Y" re "Ar";
	fx  = re "Rn" re "Ar";
	xx  = re re;
	while (match(molecule, fxx "|" fx "|" xx)) {
		mlen = length(molecule);
		end  = RSTART + RLENGTH;
		head = substr(molecule, 1, RSTART - 1);
		tail = substr(molecule, end, mlen - end + 1);
		molecule = head "e" tail;
		nsteps++;
	}
	print nsteps;
}
