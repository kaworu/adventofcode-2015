#!/usr/bin/awk -f

BEGIN {
	MAGIC_MISSILE_MANA_COST = 53;
	MAGIC_MISSILE_DAMAGE    = 4;
	DRAIN_MANA_COST = 73;
	DRAIN_DAMAGE    =  2;
	DRAIN_HEAL      =  DRAIN_DAMAGE;
	SHIELD_MANA_COST = 113;
	SHIELD_TIMER     =   6;
	SHIELD_ARMOR     =   7;
	POISON_MANA_COST = 173;
	POISON_TIMER     =   6;
	POISON_DAMAGE    =   3;
	RECHARGE_MANA_COST = 229;
	RECHARGE_TIMER     =   5;
	RECHARGE_MANA      = 101;
}

/^Hit Points: [0-9]+$/ {
	boss_hp = int($3);
}

/^Damage: [0-9]+$/ {
	boss_damage = int($2);
}

END {
	# Depth-first bruteforce search. The mana usage is correlated with the
	# turn count, hence DFS using a global game state queue instead of BFS.

	# initial state
	init["boss_hp"]        = boss_hp;
	init["my_hp"]          =  50;
	init["my_mana"]        = 500;
	init["shield_timer"]   =   0;
	init["poison_timer"]   =   0;
	init["recharge_timer"] =   0;
	init["mana_spent"]     =   0;
	enqueue(init);

	do {
		dequeue(state);
		# if this game's mana spent is already above the minimum we
		# found, skip it.
		if (min_mana_spent && state["mana_spent"] >= min_mana_spent)
			continue;
		if (apply_effects(state)) {
			# NOTE: since we use DPS, the order of the spell here
			# doesn't matter.
			cast_magic_missile(state);
			cast_drain(state);
			cast_shield(state);
			cast_poison(state);
			cast_recharge(state);
		}
	} while (tail > head);
	print min_mana_spent;
}

# Returns 1 if the game goes on, 0 otherwise.
# NOTE: only the boss dying to poison damage can end the game when applying
#       effects.
function apply_effects(state) {
	if (state["poison_timer"]) {
		state["poison_timer"] -= 1;
		state["boss_hp"] -= POISON_DAMAGE;
		if (game_over(state))
			return 0;
	}
	if (state["shield_timer"])
		state["shield_timer"] -= 1;
	if (state["recharge_timer"]) {
		state["recharge_timer"] -= 1;
		state["my_mana"] += RECHARGE_MANA;
	}
	return 1;
}

# Returns 1 if the game has ended, 0 otherwise. If we won the game and the mana
# spent is least amount of mana spent to win, save it in `min_mana_spent'.
function game_over(state,    died, killed) {
	died   = state["my_hp"]   < 1;
	killed = state["boss_hp"] < 1;
	if (killed && !died &&
	    (!min_mana_spent || min_mana_spent > state["mana_spent"])) {
		min_mana_spent = state["mana_spent"];
	}
	return (died || killed);
}

function cast_magic_missile(state,    next_state) {
	if (state["my_mana"] > MAGIC_MISSILE_MANA_COST) {
		copy(state, next_state);
		next_state["mana_spent"] += MAGIC_MISSILE_MANA_COST;
		next_state["my_mana"]    -= MAGIC_MISSILE_MANA_COST;
		next_state["boss_hp"]    -= MAGIC_MISSILE_DAMAGE;
		boss_turn(next_state);
	}
}

function cast_drain(state,    next_state) {
	if (state["my_mana"] > DRAIN_MANA_COST) {
		copy(state, next_state);
		next_state["mana_spent"] += DRAIN_MANA_COST;
		next_state["my_mana"]    -= DRAIN_MANA_COST;
		next_state["boss_hp"]    -= DRAIN_DAMAGE;
		next_state["my_hp"]      += DRAIN_HEAL;
		boss_turn(next_state);
	}
}

function cast_shield(state,    next_state) {
	if (state["my_mana"] > SHIELD_MANA_COST && !state["shield_timer"]) {
		copy(state, next_state);
		next_state["mana_spent"]   += SHIELD_MANA_COST;
		next_state["my_mana"]      -= SHIELD_MANA_COST;
		next_state["shield_timer"] += SHIELD_TIMER;
		if (!game_over(next_state))
			boss_turn(next_state);
	}
}

function cast_poison(state,    next_state) {
	if (state["my_mana"] > POISON_MANA_COST && !state["poison_timer"]) {
		copy(state, next_state);
		next_state["mana_spent"]   += POISON_MANA_COST;
		next_state["my_mana"]      -= POISON_MANA_COST;
		next_state["poison_timer"] += POISON_TIMER;
		if (!game_over(next_state))
			boss_turn(next_state);
	}
}

function cast_recharge(state,    next_state) {
	if (state["my_mana"] > RECHARGE_MANA_COST && !state["recharge_timer"]) {
		copy(state, next_state);
		next_state["mana_spent"]     += RECHARGE_MANA_COST;
		next_state["my_mana"]        -= RECHARGE_MANA_COST;
		next_state["recharge_timer"] += RECHARGE_TIMER;
		if (!game_over(next_state))
			boss_turn(next_state);
	}
}

function boss_turn(state,    armor, dmg) {
	if (apply_effects(state)) {
		armor = (state["shield_timer"] ? SHIELD_ARMOR : 0);
		dmg = one_or_more(boss_damage - armor);
		state["my_hp"] -= dmg;
		if (!game_over(state))
			enqueue(state);
	}
}

# Copy an array x into y.
function copy(x, y,    i) {
	delete y;
	for (i in x)
		y[i] = x[i];
}

# Add the given state to the global game state queue.
function enqueue(state) {
	queue[++tail] = state_to_s(state);
}

# Set the given state to the first game state from the global queue.
function dequeue(state) {
	s_to_state(queue[++head], state);
}

# Return a string representation of the given state.
# This function is used to serialize a game state, because we can't have array
# of arrays and we need to store game states in the globale queue.
function state_to_s(state,    i, s) {
	for (i in state)
		s = (s ? s " " : "") i "=" state[i];
	return s;
}

# Parse a given state string `s' into the given state array. This function is
# used to unserialize a game state, see state_to_s().
function s_to_state(s, state,    xs, x, keyval) {
	split(s, xs);
	for (x in xs) {
		split(xs[x], keyval, "=");
		state[keyval[1]] = keyval[2];
	}
}

function one_or_more(x) {
	return (x < 1 ? 1 : x);
}
