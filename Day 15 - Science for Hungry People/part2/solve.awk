#!/usr/bin/awk -f
BEGIN {
	CALORIES = 500; # exact number of calories wanted
}

/[A-Za-z]+: capacity -?[0-9]+, durability -?[0-9]+, flavor -?[0-9]+, texture -?[0-9]+, calories [0-9]+/ {
	ingredient = $1;
	sub(/:$/, "", ingredient);
	capacity[ingredient]   = int($3);
	durability[ingredient] = int($5);
	flavor[ingredient]     = int($7);
	texture[ingredient]    = int($9);
	calories[ingredient]   = int($11);
	ingredients[++ningredients] = ingredient;
}

END {
	print best_score(100, ingredients, ningredients);
}

function best_score(teaspoons, ingredients, ningredients, c, d, f, t, k,
		    i, ingredient, ci, di, fi, ti, ki, nki, s, best) {
	if (ningredients == 0) {
		if (k != CALORIES || c <= 0 || d <= 0 || f <= 0 || t <= 0)
			return 0;
		else
			return c * d * f * t;
	}

	ingredient = ingredients[ningredients];
	delete ingredients[ningredients];

	ci = capacity[ingredient];
	di = durability[ingredient];
	fi = flavor[ingredient];
	ti = texture[ingredient];
	ki = calories[ingredient];

	# if we're the last ingredient, just take all the teaspoons left.
	for (i = (ningredients == 1 ? teaspoons : 0); i <= teaspoons; i++) {
		nki = k + ki * i;
		# shortcut if we can avoid recursing. Not as clean as in the
		# stop condition but the performance impact cannot be
		# overlooked.
		if (nki > CALORIES)
			continue;
		s = best_score(teaspoons - i,
		    ingredients, ningredients - 1,
		    c + ci * i, d + di * i, f + fi * i, t + ti * i, nki);
		best = (s > best ? s : best);
	}
	ingredients[ningredients] = ingredient;

	return best;
}
