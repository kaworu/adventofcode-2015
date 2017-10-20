#!/usr/bin/awk -f

BEGIN {
	_cosmo_init();
}

{
	puzzle = $0;
}

END {
	id = seq2id[puzzle];
	if (!id) {
		# we could try to split here, but meh.
		print "bouhou, not an atom: " puzzle;
		exit;
	}

	print evolved_length(id);
}

function evolved_length(id, generation,
		n, atoms, i, len)
{
	if (generation == 50)
		return id2len[id];

	n = split(id2next[id], atoms, SUBSEP);
	for (i = 1; i <= n; i++)
		len += evolved_length(atoms[i], generation + 1);

	return len;

}

# see http://www.njohnston.ca/2010/10/a-derivation-of-conways-degree-71-look-and-say-polynomial/
function _cosmo_init()
{
	# sequence to index
	seq2id["1112"]                                       =  1;
	seq2id["1112133"]                                    =  2;
	seq2id["111213322112"]                               =  3;
	seq2id["111213322113"]                               =  4;
	seq2id["1113"]                                       =  5;
	seq2id["11131"]                                      =  6;
	seq2id["111311222112"]                               =  7;
	seq2id["111312"]                                     =  8;
	seq2id["11131221"]                                   =  9;
	seq2id["1113122112"]                                 = 10;
	seq2id["1113122113"]                                 = 11;
	seq2id["11131221131112"]                             = 12;
	seq2id["111312211312"]                               = 13;
	seq2id["11131221131211"]                             = 14;
	seq2id["111312211312113211"]                         = 15;
	seq2id["111312211312113221133211322112211213322112"] = 16;
	seq2id["111312211312113221133211322112211213322113"] = 17;
	seq2id["11131221131211322113322112"]                 = 18;
	seq2id["11131221133112"]                             = 19;
	seq2id["1113122113322113111221131221"]               = 20;
	seq2id["11131221222112"]                             = 21;
	seq2id["111312212221121123222112"]                   = 22;
	seq2id["111312212221121123222113"]                   = 23;
	seq2id["11132"]                                      = 24;
	seq2id["1113222"]                                    = 25;
	seq2id["1113222112"]                                 = 26;
	seq2id["1113222113"]                                 = 27;
	seq2id["11133112"]                                   = 28;
	seq2id["12"]                                         = 29;
	seq2id["123222112"]                                  = 30;
	seq2id["123222113"]                                  = 31;
	seq2id["12322211331222113112211"]                    = 32;
	seq2id["13"]                                         = 33;
	seq2id["131112"]                                     = 34;
	seq2id["13112221133211322112211213322112"]           = 35;
	seq2id["13112221133211322112211213322113"]           = 36;
	seq2id["13122112"]                                   = 37;
	seq2id["132"]                                        = 38;
	seq2id["13211"]                                      = 39;
	seq2id["132112"]                                     = 40;
	seq2id["1321122112"]                                 = 41;
	seq2id["132112211213322112"]                         = 42;
	seq2id["132112211213322113"]                         = 43;
	seq2id["132113"]                                     = 44;
	seq2id["1321131112"]                                 = 45;
	seq2id["13211312"]                                   = 46;
	seq2id["1321132"]                                    = 47;
	seq2id["13211321"]                                   = 48;
	seq2id["132113212221"]                               = 49;
	seq2id["13211321222113222112"]                       = 50;
	seq2id["1321132122211322212221121123222112"]         = 51;
	seq2id["1321132122211322212221121123222113"]         = 52;
	seq2id["13211322211312113211"]                       = 53;
	seq2id["1321133112"]                                 = 54;
	seq2id["1322112"]                                    = 55;
	seq2id["1322113"]                                    = 56;
	seq2id["13221133112"]                                = 57;
	seq2id["1322113312211"]                              = 58;
	seq2id["132211331222113112211"]                      = 59;
	seq2id["13221133122211332"]                          = 60;
	seq2id["22"]                                         = 61;
	seq2id["3"]                                          = 62;
	seq2id["3112"]                                       = 63;
	seq2id["3112112"]                                    = 64;
	seq2id["31121123222112"]                             = 65;
	seq2id["31121123222113"]                             = 66;
	seq2id["3112221"]                                    = 67;
	seq2id["3113"]                                       = 68;
	seq2id["311311"]                                     = 69;
	seq2id["31131112"]                                   = 70;
	seq2id["3113112211"]                                 = 71;
	seq2id["3113112211322112"]                           = 72;
	seq2id["3113112211322112211213322112"]               = 73;
	seq2id["3113112211322112211213322113"]               = 74;
	seq2id["311311222"]                                  = 75;
	seq2id["311311222112"]                               = 76;
	seq2id["311311222113"]                               = 77;
	seq2id["3113112221131112"]                           = 78;
	seq2id["311311222113111221"]                         = 79;
	seq2id["311311222113111221131221"]                   = 80;
	seq2id["31131122211311122113222"]                    = 81;
	seq2id["3113112221133112"]                           = 82;
	seq2id["311312"]                                     = 83;
	seq2id["31132"]                                      = 84;
	seq2id["311322113212221"]                            = 85;
	seq2id["311332"]                                     = 86;
	seq2id["3113322112"]                                 = 87;
	seq2id["3113322113"]                                 = 88;
	seq2id["312"]                                        = 89;
	seq2id["312211322212221121123222113"]                = 90;
	seq2id["312211322212221121123222112"]                = 91;
	seq2id["32112"]                                      = 92;

	id2len[1]  =  4;
	id2len[2]  =  7;
	id2len[3]  = 12;
	id2len[4]  = 12;
	id2len[5]  =  4;
	id2len[6]  =  5;
	id2len[7]  = 12;
	id2len[8]  =  6;
	id2len[9]  =  8;
	id2len[10] = 10;
	id2len[11] = 10;
	id2len[12] = 14;
	id2len[13] = 12;
	id2len[14] = 14;
	id2len[15] = 18;
	id2len[16] = 42;
	id2len[17] = 42;
	id2len[18] = 26;
	id2len[19] = 14;
	id2len[20] = 28;
	id2len[21] = 14;
	id2len[22] = 24;
	id2len[23] = 24;
	id2len[24] =  5;
	id2len[25] =  7;
	id2len[26] = 10;
	id2len[27] = 10;
	id2len[28] =  8;
	id2len[29] =  2;
	id2len[30] =  9;
	id2len[31] =  9;
	id2len[32] = 23;
	id2len[33] =  2;
	id2len[34] =  6;
	id2len[35] = 32;
	id2len[36] = 32;
	id2len[37] =  8;
	id2len[38] =  3;
	id2len[39] =  5;
	id2len[40] =  6;
	id2len[41] = 10;
	id2len[42] = 18;
	id2len[43] = 18;
	id2len[44] =  6;
	id2len[45] = 10;
	id2len[46] =  8;
	id2len[47] =  7;
	id2len[48] =  8;
	id2len[49] = 12;
	id2len[50] = 20;
	id2len[51] = 34;
	id2len[52] = 34;
	id2len[53] = 20;
	id2len[54] = 10;
	id2len[55] =  7;
	id2len[56] =  7;
	id2len[57] = 11;
	id2len[58] = 13;
	id2len[59] = 21;
	id2len[60] = 17;
	id2len[61] =  2;
	id2len[62] =  1;
	id2len[63] =  4;
	id2len[64] =  7;
	id2len[65] = 14;
	id2len[66] = 14;
	id2len[67] =  7;
	id2len[68] =  4;
	id2len[69] =  6;
	id2len[70] =  8;
	id2len[71] = 10;
	id2len[72] = 16;
	id2len[73] = 28;
	id2len[74] = 28;
	id2len[75] =  9;
	id2len[76] = 12;
	id2len[77] = 12;
	id2len[78] = 16;
	id2len[79] = 18;
	id2len[80] = 24;
	id2len[81] = 23;
	id2len[82] = 16;
	id2len[83] =  6;
	id2len[84] =  5;
	id2len[85] = 15;
	id2len[86] =  6;
	id2len[87] = 10;
	id2len[88] = 10;
	id2len[89] =  3;
	id2len[90] = 27;
	id2len[91] = 27;
	id2len[92] =  5;

	id2next[1]  = 63;
	id2next[2]  = 64 SUBSEP 62;
	id2next[3]  = 65;
	id2next[4]  = 66;
	id2next[5]  = 68;
	id2next[6]  = 69;
	id2next[7]  = 84 SUBSEP 55;
	id2next[8]  = 70;
	id2next[9]  = 71;
	id2next[10] = 76;
	id2next[11] = 77;
	id2next[12] = 82;
	id2next[13] = 78;
	id2next[14] = 79;
	id2next[15] = 80;
	id2next[16] = 81 SUBSEP 29 SUBSEP 91;
	id2next[17] = 81 SUBSEP 29 SUBSEP 90;
	id2next[18] = 81 SUBSEP 30;
	id2next[19] = 75 SUBSEP 29 SUBSEP 92;
	id2next[20] = 75 SUBSEP 32;
	id2next[21] = 72;
	id2next[22] = 73;
	id2next[23] = 74;
	id2next[24] = 83;
	id2next[25] = 86;
	id2next[26] = 87;
	id2next[27] = 88;
	id2next[28] = 89 SUBSEP 92;
	id2next[29] = 1;
	id2next[30] = 3;
	id2next[31] = 4;
	id2next[32] = 2 SUBSEP 61 SUBSEP 29 SUBSEP 85;
	id2next[33] = 5;
	id2next[34] = 28;
	id2next[35] = 24 SUBSEP 33 SUBSEP 61 SUBSEP 29 SUBSEP 91;
	id2next[36] = 24 SUBSEP 33 SUBSEP 61 SUBSEP 29 SUBSEP 90;
	id2next[37] = 7;
	id2next[38] = 8;
	id2next[39] = 9;
	id2next[40] = 10;
	id2next[41] = 21;
	id2next[42] = 22;
	id2next[43] = 23;
	id2next[44] = 11;
	id2next[45] = 19;
	id2next[46] = 12;
	id2next[47] = 13;
	id2next[48] = 14;
	id2next[49] = 15;
	id2next[50] = 18;
	id2next[51] = 16;
	id2next[52] = 17;
	id2next[53] = 20;
	id2next[54] = 6 SUBSEP 61 SUBSEP 29 SUBSEP 92;
	id2next[55] = 26;
	id2next[56] = 27;
	id2next[57] = 25 SUBSEP 29 SUBSEP 92;
	id2next[58] = 25 SUBSEP 29 SUBSEP 67;
	id2next[59] = 25 SUBSEP 29 SUBSEP 85;
	id2next[60] = 25 SUBSEP 29 SUBSEP 68 SUBSEP 61 SUBSEP 29 SUBSEP 89;
	id2next[61] = 61;
	id2next[62] = 33;
	id2next[63] = 40;
	id2next[64] = 41;
	id2next[65] = 42;
	id2next[66] = 43;
	id2next[67] = 38 SUBSEP 39;
	id2next[68] = 44;
	id2next[69] = 48;
	id2next[70] = 54;
	id2next[71] = 49;
	id2next[72] = 50;
	id2next[73] = 51;
	id2next[74] = 52;
	id2next[75] = 47 SUBSEP 38;
	id2next[76] = 47 SUBSEP 55;
	id2next[77] = 47 SUBSEP 56;
	id2next[78] = 47 SUBSEP 57;
	id2next[79] = 47 SUBSEP 58;
	id2next[80] = 47 SUBSEP 59;
	id2next[81] = 47 SUBSEP 60;
	id2next[82] = 47 SUBSEP 33 SUBSEP 61 SUBSEP 29 SUBSEP 92;
	id2next[83] = 45;
	id2next[84] = 46;
	id2next[85] = 53;
	id2next[86] = 38 SUBSEP 29 SUBSEP 89;
	id2next[87] = 38 SUBSEP 30;
	id2next[88] = 38 SUBSEP 31;
	id2next[89] = 34;
	id2next[90] = 36;
	id2next[91] = 35;
	id2next[92] = 37;
}
