%start expr
%token <dval> NUMBER
%type<dval> expr, term, factor

%%

/* GRAMÁTICA 1 */

expr	: term				{}
		| expr "+" term		{ $$ = $1 + $3; }
		| expr "-" term		{ $$ = $1 - $3; }
;

term	: factor
		| term "*" factor	{ $$ = $1 * $3; }
		| term "/" factor	{ $$ = $1 / $3; }
;

factor	: NUMBER			{ $$ = $1; }
;

/* GRAMÁTICA 2
 
 expr	: term				{}
 | term "+" expr		{ $$ = $1 + $3; }
 | term "-" expr		{ $$ = $1 - $3; }
 ;
 
 term	: factor
 | factor "*" term	{ $$ = $1 * $3; }
 | factor "/" term	{ $$ = $1 / $3; }
 ;
 
 factor	: NUMBER			{ $$ = $1; }
 ;
 
 */

%%

private Lexer yylexer;

public static void main(String[] args) {
	if (args.length == 0) {
		System.err.println("[ERROR] No se especificó ningún archivo.");
		System.exit(1);
	}
	
	try {
		Parser yyparser = new Parser(new java.io.FileReader(args[0]));
		yyparser.yyparse();
		System.out.println("[OK]");
	} catch (java.io.FileNotFoundException e){
		System.err.println("[ERROR] El archivo \"" + args[0] + "\" no existe.");
	}
}

public Parser(java.io.Reader reader){
	yylexer = new Lexer(reader, this);
}

public void yyerror (String error){
	System.err.println("[ERROR] La expresión aritmética no está bien formada.");
	System.exit(2);
}

private int yylex() {
	int yyl_return = -1;

	try {
		yyl_return = yylexer.yylex();
	} catch (java.io.IOException e){
    	System.err.println("[ERROR] " + e);
  	}
	
  	return yyl_return;
}






