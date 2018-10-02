package lexico;

import java.util.Stack;
import java.io.Writer;

/**
 * Clase que representa un analizador léxico simple para Python.
 */
%%

%public
%class Flexer
%unicode
%line
%column
%intwrap

%{
	/** Estructura que acumula la salida de este programa. */
	private StringBuilder salida;

	/** Aquí se escribirá el contenido de salida al terminar la lectura. */	
	private Writer writer;

	/** Pila que acumula los niveles de indentación. */
	private Stack<Integer> indentaciones;

	/** Como yyclose() no termina el scanning inmediatamente, se pueden seguir
	    agregando errores a salida, pero sólo queremos que se muestre uno. 
	    Si sucede eso, este entero guarda el índice a partir del cual se
	    agregaron errores de más. */
	private int len;

	/** Regresa el valor de zzAtEOF. */
	public boolean getZzAtEOF() {
		return zzAtEOF;
	}

	/** Lógica relacionada con la indentación, deindentación, y saltos de línea. */
	private void procesarIndentacion() {
		/* Si salida está vacío significa que la primera línea,
		   y posiblemente algunas que siguen, están vacías. */ 
		if (salida.length() != 0) {
			salida.append("SALTO\n");
		}
		
		int indentacionPrevia = (indentaciones.empty()) ? 0 : indentaciones.peek();

		if (yycolumn > indentacionPrevia) {
			indentaciones.push(yycolumn);
			concatenar("INDENTA", yycolumn);
		} else if (yycolumn < indentacionPrevia) {
			/* Si la línea actual está indentada pero no había sido empezado ese bloque
			   entonces hay un error de indentación. */
			if (yycolumn > 0 && indentaciones.search(yycolumn) == -1) {
				lanzarError("Error de indentación.");
			}
			/* Se hace pop a la pila en búsqueda del bloque al que pertenece. */
			while (yycolumn != indentacionPrevia && !indentaciones.empty()) {
				indentacionPrevia = indentaciones.pop();
				concatenar("DEINDENTA", (yycolumn == 0) ? indentacionPrevia : yycolumn);
				salida.append("\n");
				if (!indentaciones.empty()) {
					indentacionPrevia = indentaciones.peek();
				}
			} 
		} // Si yycolumn == indentacionPrevia, no se hace nada.
	}

	/** Concatena la cadena "<s>(yytext())" a la salida. */
	private void concatenar(String s) {
		salida.append(s + "(" + yytext() + ")");
	}

	/** Concatena la cadena "<s1>(<s2>)" a la salida. */
	private void concatenar(Object s1, Object s2) {
		salida.append(s1.toString() + "(" + s2.toString() + ")");
	}

	/** Muestra el mensaje dado y termina el programa. */
	private void lanzarError(String mensaje) {
		salida.append("\nLínea " + (yyline + 1) + ": " + mensaje);
		len = (len > 0) ? len : salida.length();
		try {
			yyclose();
		} catch (java.io.IOException ioe) {}
	}
%}

%ctorarg Writer writer
%init{
	salida = new StringBuilder();
	this.writer = writer;
	indentaciones = new Stack<>();
%init}

%eofthrow java.io.IOException
%eof{
	if (!indentaciones.empty()) {
		salida.append("SALTO");
	}
	while (!indentaciones.empty()) {
		concatenar("\nDEINDENTA", indentaciones.pop());
	}
	writer.write((len != 0) ? salida.substring(0, len) : salida.toString());
%eof}

BOOLEANO 		= True|False
ENTERO 			= [1-9][0-9]* | 0+
REAL 			= (\.[0-9]+)|{ENTERO}\.[0-9]*
RESERVADA 		= and|or|not|while|if|else|elif|print
IDENTIFICADOR 	= [:letter:]([:letter:]|[0-9]|\_)*
COMUN 			= \+|\-|\*|\/|\%|\<|\>|\=
OPERADOR 		= {COMUN}|{COMUN}\=|\!\=
SEPARADOR 		= \:

%xstate CADENA, SALTO

%%

{BOOLEANO}			{ concatenar("BOOLEANO"); }
{ENTERO}			{ concatenar("ENTERO"); }
{REAL}				{ concatenar("REAL"); }
{RESERVADA}			{ concatenar("RESERVADA"); }
{IDENTIFICADOR}		{ concatenar("IDENTIFICADOR"); }
{OPERADOR}			{ concatenar("OPERADOR"); }
{SEPARADOR}			{ concatenar("SEPARADOR"); }
\"					{ yybegin(CADENA); }
^\s+				{ yytext().replaceAll("\t", "    "); yybegin(SALTO); }
\R\s* 				{ yytext().replaceAll("\t", "    "); yybegin(SALTO); }
[ ]					{ /* Se requiere esta acción vacía para que los espacios 
						 sean reconocidos por alguna expresión. */ }
[^]					{ lanzarError("Caracter no reconocido '" + yytext() + "'."); }

<CADENA> {
	[^\\\"]+\" 		{ concatenar("CADENA", yytext().substring(0, yytext().length() - 1)); 
					  yybegin(YYINITIAL); }
	[^]				{ lanzarError("Cadena mal formada"); }
}

<SALTO> {
	\S 				{ procesarIndentacion();
				  	  yypushback(1); 
				  	  yybegin(YYINITIAL); }
	\R 				{ /* Se requiere esta acción vacía para que las líneas
						 vacías sean reconocidas por alguna expresión. */ }
}