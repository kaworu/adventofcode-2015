#!/usr/bin/awk -f

/[A-Za-z]+ => [A-Za-z]+/ {
	from = $1;
	to   = $3;
	atoms[from] = 1;
	# NOTE:
	# replacements[x] is the count of replacements for the atom x.
	# replacements[x, i] is the ith replacements for the atom x.
	replacements[from, ++replacements[from]] = to;
}

/^[A-Za-z]+$/ {
	molecule = $1;
}

END {
	# build a regular expression matching any atom.
	for (a in atoms)
		re = (re ? re "|" a : a);
	re = "(" re ")";

	# Given "xy", a replacement for "x" MUST be of the form "x?" to pair
	# with "?y", a matching replacement for "y". In this case we have a
	# duplicate replacement yielding "x?y" in both cases.
	#
	# We build lrep and rrep so that they contains the common "?" part in
	# the same way we've built replacements. From our example we would
	# have:
	#     lrep[x, a] = rrep[y, b] = "?"
	# where a (respectively b) is an increment of left replacements for x
	# (respectively right replacements for y).
	for (a in atoms) {
		for (i = 1; replacements[a, i]; i++) {
			r = suround(replacements[a, i], re);
			leftre  = "^" a "@";
			rightre = "@" a "$";
			if (r ~ leftre) {
				lrep[a, ++lrep[a]] = r
				sub(leftre, "",  lrep[a, lrep[a]]);
			}
			if (r ~ rightre) {
				rrep[a, ++rrep[a]] = r
				sub(rightre, "",  rrep[a, rrep[a]]);
			}
		}
	}

	n = split(suround(molecule, re), puzzle, "@");
	for (i = 1; i <= n; i++) {
		a = puzzle[i];
		prev = puzzle[i - 1];
		distinct += replacements[a] - dup(prev, a);
	}
	print distinct;
}

# "suround" atoms by a marker, so that we can easily split the string.
function suround(s, r) {
	gsub(r, "@&@", s);
	gsub(/@@/, "@", s); # remove double markers
	sub(/^@/, "", s); # remove the leading marker
	sub(/@$/, "", s); # remove the trailing marker
	return s;
}

# return the number of duplicate substitutions for the sequence of atoms "xy"
function dup(x, y,    ix, iy, ndup) {
	if ((x, y) in _dup) # memoized
		return _dup[x, y];
	# NOTE: could use something like a binary search if we had either lrep
	# or rrep sorted (or both), but lrep[x] and rrep[y] are small.
	for (ix = 1; ix <= lrep[x]; ix++) {
		for (iy = 1; iy <= rrep[y]; iy++)
			ndup += (lrep[x, ix] == rrep[y, iy]);
	}
	return _dup[x, y] = ndup;
}
