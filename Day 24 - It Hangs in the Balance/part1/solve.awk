#!/usr/bin/awk -f

BEGIN {
	NGROUPS = 3;
}

{
	# NOTE: Conveniently, the puzzle input is already sorted (ascending).
	packages[NR]  = $0;
	total_weigth += $0;
}

END {
	balance(total_weigth / NGROUPS, NR);
	print min_qe;
}

function balance(weight, n, set, len,    i, w, s, l, qe) {
	l = len + 1;
	# shortcut if we already found a solution with less packages.
	if (min_len && l > min_len)
		return;
	# NOTE: go backwards through the packages since it is sorted in
	# ascending order.
	for (i = n; i > 0; i--) {
		w = weight - packages[i];
		s = (len ? set FS : "") packages[i];
		if (w > 0) {
			balance(w, i - 1, s, l);
		} else if (w == 0) { # our set `s' is a solution
			qe = quantum_entanglement(s);
			if (!min_len || l < min_len || qe < min_qe) {
				# `s' has the minimum package count so far, or
				# it has a lower quantum entanglement.
				min_len = l;
				min_qe  = qe;
			}
		}
	}
}

function quantum_entanglement(set,    qe, n, xs, i) {
	qe = 1;
	n = split(set, xs);
	for (i = 1; i <= n; i++)
		qe *= xs[i];
	return qe;
}
