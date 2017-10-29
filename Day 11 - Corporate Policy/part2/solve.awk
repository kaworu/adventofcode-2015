#!/usr/bin/awk -f
BEGIN {
	_ord_init();
	_inc_init();
}

{
	puzzle_length = split($0, puzzle, "");

	# "translate" puzzle characters into numbers:
	# a=0, b=1, c=2, ..., z=25
	for (i = 1; i <= puzzle_length; i++)
		puzzle[i] = ord(puzzle[i]);
}

END {
	while (!(has_a_straight_of_three() && has_two_pairs()))
		advance(puzzle);
	advance(puzzle);
	while (!(has_a_straight_of_three() && has_two_pairs()))
		advance(puzzle);
	for (i = 1; i <= puzzle_length; i++)
		printf("%c", puzzle[i]);
	printf("\n");
}

# first rule.
function has_a_straight_of_three(i, n)
{
	n = 1;
	for (i = 2; i <= puzzle_length; i++) {
		if (puzzle[i] != puzzle[i - 1] + 1)
			n = 1;
		else if (++n >= 3)
			return 1;
	}
	return 0;
}

# third rule.
function has_two_pairs(i, n)
{
	for (i = 2; i <= puzzle_length; i++) {
		if (puzzle[i] == puzzle[i - 1]) {
			i++;
			if (++n >= 2)
				return 1;
		}
	}
	return 0;
}

function advance(puzzle, orda, i)
{
	# iter over the puzzle from the last element to the first
	for (i = puzzle_length; i > 0; i--) {
		puzzle[i] = inc[puzzle[i]];
		if (puzzle[i] == ord("a")) # we did wrap.
			continue;
		return i;
	}
}

# from https://www.gnu.org/software/gawk/manual/html_node/Ordinal-Functions.html
function _ord_init(    i)
{
	for (i = 0; i < 256; i++)
		_ord_[sprintf("%c", i)] = i;
}

function ord(s)
{
	# only first character is of interest
	#return _ord_[substr(s, 1, 1)];
	return _ord_[s];
}

function _inc_init()
{
	inc[ord("a")] = ord("b");
	inc[ord("b")] = ord("c");
	inc[ord("c")] = ord("d");
	inc[ord("d")] = ord("e");
	inc[ord("e")] = ord("f");
	inc[ord("f")] = ord("g");
	inc[ord("g")] = ord("h");
	inc[ord("h")] = ord("j");
	inc[ord("j")] = ord("k");
	inc[ord("k")] = ord("m");
	inc[ord("m")] = ord("n");
	inc[ord("n")] = ord("p");
	inc[ord("p")] = ord("q");
	inc[ord("q")] = ord("r");
	inc[ord("r")] = ord("s");
	inc[ord("s")] = ord("t");
	inc[ord("t")] = ord("u");
	inc[ord("u")] = ord("v");
	inc[ord("v")] = ord("x");
	inc[ord("x")] = ord("y");
	inc[ord("y")] = ord("z");
	inc[ord("z")] = ord("a");
}
