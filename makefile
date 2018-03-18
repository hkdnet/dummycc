bin/dummyc: lex.yy.c y.tab.c
	gcc -o bin/dummyc y.tab.c lex.yy.c
y.tab.c: parse.y
	yacc -dv parse.y
lex.yy.c: dummyc.l
	lex dummyc.l

