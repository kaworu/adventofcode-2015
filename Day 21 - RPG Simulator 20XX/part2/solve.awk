#!/usr/bin/awk -f
BEGIN {
	shop["weapons", ++nweapons, "name"]   = "Dagger";
	shop["weapons",   nweapons, "cost"]   = 8;
	shop["weapons",   nweapons, "damage"] = 4;
	shop["weapons", ++nweapons, "name"]   = "Shortsword";
	shop["weapons",   nweapons, "cost"]   = 10;
	shop["weapons",   nweapons, "damage"] = 5;
	shop["weapons", ++nweapons, "name"]   = "Warhammer";
	shop["weapons",   nweapons, "cost"]   = 25;
	shop["weapons",   nweapons, "damage"] = 6;
	shop["weapons", ++nweapons, "name"]   = "Longsword";
	shop["weapons",   nweapons, "cost"]   = 40;
	shop["weapons",   nweapons, "damage"] = 7;
	shop["weapons", ++nweapons, "name"]   = "Greataxe";
	shop["weapons",   nweapons, "cost"]   = 74;
	shop["weapons",   nweapons, "damage"] = 8;
	shop["armors",  ++narmors,  "name"]   = "Leather";
	shop["armors",    narmors,  "cost"]   = 13;
	shop["armors",    narmors,  "armor"]  = 1;
	shop["armors",  ++narmors,  "name"]   = "Chainmail";
	shop["armors",    narmors,  "cost"]   = 31;
	shop["armors",    narmors,  "armor"]  = 2;
	shop["armors",  ++narmors,  "name"]   = "Splintmail";
	shop["armors",    narmors,  "cost"]   = 53;
	shop["armors",    narmors,  "armor"]  = 3;
	shop["armors",  ++narmors,  "name"]   = "Bandedmail";
	shop["armors",    narmors,  "cost"]   = 75;
	shop["armors",    narmors,  "armor"]  = 4;
	shop["armors",  ++narmors,  "name"]   = "Platemail";
	shop["armors",    narmors,  "cost"]   = 102;
	shop["armors",    narmors,  "armor"]  = 5;
	shop["rings",   ++nrings,   "name"]   = "Damage +1";
	shop["rings",     nrings,   "cost"]   = 25;
	shop["rings",     nrings,   "damage"] = 1;
	shop["rings",   ++nrings,   "name"]   = "Damage +2";
	shop["rings",     nrings,   "cost"]   = 50;
	shop["rings",     nrings,   "damage"] = 2;
	shop["rings",   ++nrings,   "name"]   = "Damage +3";
	shop["rings",     nrings,   "cost"]   = 100;
	shop["rings",     nrings,   "damage"] = 3;
	shop["rings",   ++nrings,   "name"]   = "Defense +1";
	shop["rings",     nrings,   "cost"]   = 20;
	shop["rings",     nrings,   "armor"]  = 1;
	shop["rings",   ++nrings,   "name"]   = "Defense +2";
	shop["rings",     nrings,   "cost"]   = 40;
	shop["rings",     nrings,   "armor"]  = 2;
	shop["rings",   ++nrings,   "name"]   = "Defense +3";
	shop["rings",     nrings,   "cost"]   = 80;
	shop["rings",     nrings,   "armor"]  = 3;
	my_hp = 100;
}

/^Hit Points: [0-9]+$/ {
	boss_hp = int($3);
}

/^Damage: [0-9]+$/ {
	boss_damage = int($2);
}

/^Armor: [0-9]+$/ {
	boss_armor = int($2);
}

END {
	# the logic is complex, the space is small, we play once. Let's
	# bruteforce this. I tried something clever before this one, it worked
	# but was an order of magnitude more complex.

	# start weapon at 1, because we must have one.
	for (weapon = 1; weapon <= nweapons; weapon++) {
		# start armors at zero, being no armor.
		for (armor = 0; armor <= narmors; armor++) {
			for (left_ring = 0; left_ring <= nrings; left_ring++) {
				for (right_ring = 0; right_ring <= nrings; right_ring++) {
					# we can't have the same ring on the
					# left hand and right hand at the same
					# time. No ring at all is fine though.
					if (right_ring && right_ring == left_ring)
						continue;
					cost = buy(weapon, armor, left_ring, right_ring);
					win  = fight(weapon, armor, left_ring, right_ring);
					if (!win && cost > most_expensive)
						most_expensive = cost;
				}
			}
		}
	}
	print most_expensive;
}

function buy(weapon, armor, left_ring, right_ring) {
	return \
	    shop["weapons", weapon,     "cost"] + \
	    shop["armors",  armor,      "cost"] + \
	    shop["rings",   left_ring,  "cost"] + \
	    shop["rings",   right_ring, "cost"];
}

function fight(weapon, armor, left_ring, right_ring,
	    atk, dmg, def, hit, kill, die) {
	atk = \
	    shop["weapons", weapon,     "damage"] + \
	    shop["armors",  armor,      "damage"] + \
	    shop["rings",   left_ring,  "damage"] + \
	    shop["rings",   right_ring, "damage"];
	def = \
	    shop["weapons", weapon,     "armor"] + \
	    shop["armors",  armor,      "armor"] + \
	    shop["rings",   left_ring,  "armor"] + \
	    shop["rings",   right_ring, "armor"];
	dmg  = one_or_more(atk - boss_armor);
	hit  = one_or_more(boss_damage - def);
	kill = round_up(boss_hp / dmg);
	die  = round_up(my_hp / hit);
	return (kill <= die);
}

function one_or_more(x) {
	return (x < 1 ? 1 : x);
}

function round_up(x) {
	return int(x > int(x) ? x + 1 : x);
}
