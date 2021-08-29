struct1 = {
	a : 0,
	b : 1
}
struct2 = {
	a : 0,
	b : 1
}

with(struct1) {
	a = other.struct2;
}

with(struct2)	{
	a = other.struct1;
}

try {
	DM(S(struct1));
}

catch (e) {
}

finally {
	DM(S(struct1.b))
}