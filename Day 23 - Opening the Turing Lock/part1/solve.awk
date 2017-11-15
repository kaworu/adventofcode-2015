#!/usr/bin/awk -f

# save each instruction as-is, only deleting comma for easier processing.
{
	gsub(/,/, "");
	instructions[NR] = $0;
}

END {
	registers["a"]  = 0;
	registers["b"]  = 0;
	registers["pc"] = 1;
	while (registers["pc"] <= NR)
		eval(instructions[registers["pc"]], registers);
	print registers["b"];
}

function eval(ins, regs,    xs, op, lhs, rhs) {
	split(ins, xs);
	op  = xs[1];
	lhs = xs[2];
	rhs = xs[3];
	if (op == "hlf") {
		regs[lhs] = int(regs[lhs] / 2);
		regs["pc"] += 1;
	} else if (op == "tpl") {
		regs[lhs] *= 3;
		regs["pc"] += 1;
	} else if (op == "inc") {
		regs[lhs] += 1;
		regs["pc"] += 1;
	} else if (op == "jmp") {
		regs["pc"] += lhs;
	} else if (op == "jie") {
		regs["pc"] += (regs[lhs] % 2 == 0 ? rhs : 1);
	} else if (op == "jio") {
		regs["pc"] += (regs[lhs] == 1 ? rhs : 1);
	} else {
		print ins ": unrecognized instruction";
		exit;
	}
}
