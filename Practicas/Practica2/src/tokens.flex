%%

%public
%class Lexer
%unicode
%standalone

%{
	private Parser yyparser;

	public Lexer(java.io.Reader reader, Parser yyparser) {
		this(reader);
		this.yyparser = yyparser;
	}
%}

NUMBER 	= \-?[0-9]+(\.[0-9]+)?
OP		= \+|\-|\*|\/

%%
\s|\R		{}
{OP}		{ return (int) yycharat(0); }
{NUMBER}    { return Parser.NUMBER; }
[^] 		{ System.err.println("[ERROR] Token no reconocido.");
     		  System.exit(1); }
