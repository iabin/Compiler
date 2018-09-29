import java.util.Stack;
import java.io.Writer;

/**
 * Clase que representa un analizador léxico simple para Python.
 */
%%

%public
%class Lexer
%unicode
%line
%column
%byaccj

%{
    private Parser yyparser;

    /** Pila que acumula los niveles de indentación. */
    private Stack<Integer> indentaciones;

    /** Nuevo constructor
    * @param FileReader r
    * @param parser parser - parser
    */
    public Lexer(java.io.Reader r, Parser parser){
           this(r);
           yyparser = parser;
           indentaciones = new Stack<>();
    }

    /** Regresa el valor de zzAtEOF. */
    public boolean getZzAtEOF() {
        return zzAtEOF;
    }

    /** Lógica relacionada con la indentación, deindentación, y saltos de línea. */
    private int procesarIndentacion() {
        int indentacionPrevia = (indentaciones.empty()) ? 0 : indentaciones.peek();

        if (yycolumn > indentacionPrevia) {
            indentaciones.push(yycolumn);
            yyparser.yylval = new ParserVal(yycolumn); 
            return Parser.INDENTA;
        } else if (yycolumn < indentacionPrevia) {
            /* Si la línea actual está indentada pero no había sido empezado ese bloque
               entonces hay un error de indentación. */
            if (yycolumn > 0 && indentaciones.search(yycolumn) == -1) {
                lanzarError("Error de indentación.");
            }
            /* Se hace pop a la pila en búsqueda del bloque al que pertenece. */
            if (yycolumn != indentacionPrevia && !indentaciones.empty()) {
                indentacionPrevia = indentaciones.pop();
                if (!indentaciones.empty()) {
                    indentacionPrevia = indentaciones.peek();
                }
                yyparser.yylval = new ParserVal((yycolumn == 0) ? indentacionPrevia : yycolumn); 
                return Parser.DEINDENTA;
            } 
        } 
        // Si yycolumn == indentacionPrevia, no se hace nada.
        return -1;
    }

    /** Muestra el mensaje dado y termina el programa. */
    private void lanzarError(String mensaje) {
        System.err.println("\nLínea " + (yyline + 1) + ": " + mensaje);
        System.exit(1);
    }
%}

BOOLEANO        = True|False
ENTERO          = [1-9][0-9]* | 0+
REAL            = (\.[0-9]+)|{ENTERO}\.[0-9]*
IDENTIFICADOR   = [:letter:]([:letter:]|[0-9]|\_)*

ASIG_OP         = \=
COMP_OP         = \<|\>|(\=\=)|(\>\=)|(\<\=)|(\!\=)
EXPR_OP         = \+|\-
FACTOR_OP       = \*|\/|\%
POWER_OP        = \*\*

SEPARADOR       = \:
OPEN_PAREN      = \(
CLOSE_PAREN     = \)
AND             = and
OR              = or
NOT             = not
WHILE           = while
IF              = if
ELSE            = else
PRINT           = print

%xstate CADENA, SALTO

%%

{BOOLEANO}          { yyparser.yylval = new ParserVal(Boolean.parseBoolean(yytext())); 
                      return Parser.BOOLEANO; }
{ENTERO}            { yyparser.yylval = new ParserVal(Integer.parseInt(yytext())); 
                      return Parser.ENTERO; }
{REAL}              { yyparser.yylval = new ParserVal(Double.parseDouble(yytext())); 
                      return Parser.REAL; }

{ASIG_OP}           { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.ASIG_OP; }
{COMP_OP}           { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.COMP_OP; }
{EXPR_OP}           { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.EXPR_OP; }
{FACTOR_OP}         { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.FACTOR_OP; }
{POWER_OP}          { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.POWER_OP; }

{SEPARADOR}         { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.SEPARADOR; }
{OPEN_PAREN}        { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.OPEN_PAREN; }
{CLOSE_PAREN}       { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.CLOSE_PAREN; }
{AND}               { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.AND; }
{OR}                { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.OR; }
{NOT}               { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.NOT; }
{WHILE}             { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.WHILE; } 
{IF}                { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.IF; } 
{ELSE}              { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.ELSE; } 
{PRINT}             { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.PRINT; }        

{IDENTIFICADOR}     { yyparser.yylval = new ParserVal(yytext()); 
                      return Parser.IDENTIFICADOR; }              

\"                  { yybegin(CADENA); }
^\s+                { yyparser.yylval = new ParserVal("\n"); 
                      yybegin(SALTO);
                      return Parser.SALTO; }
\R\s*               { yyparser.yylval = new ParserVal("\n"); 
                      yybegin(SALTO);
                      return Parser.SALTO; }
[ ]                 { /* Se requiere esta acción vacía para que los espacios 
                         sean reconocidos por alguna expresión. */ }
[^]                 { lanzarError("Caracter no reconocido '" + yytext() + "'."); }

<CADENA> {
    [^\\\"]+\"      { yyparser.yylval = new ParserVal(yytext().substring(0, yytext().length() - 1)); 
                      yybegin(YYINITIAL); 
                      return Parser.CADENA; }
    [^]             { lanzarError("Cadena mal formada"); }
}

<SALTO> {
    \S              { yypushback(1); 
                      yybegin(YYINITIAL); 
                      int res = procesarIndentacion();
                      if (res != -1) return res; }
    \R              { /* Se requiere esta acción vacía para que las líneas
                         vacías sean reconocidas por alguna expresión. */ }
}