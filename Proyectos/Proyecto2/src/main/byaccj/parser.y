%{

import java.io.*;

%}

%token<sval> 
  A, B,
  BOOLEANO, ENTERO, REAL, IDENTIFICADOR, CADENA
  ASIG_OP, COMP_OP, EXPR_OP, FACTOR_OP, POWER_OP,
  SEPARADOR, OPEN_PAREN, CLOSE_PAREN, AND, OR, NOT, WHILE, IF, ELSE, PRINT,
  SALTO, INDENTA, DEINDENTA

%type<sval> file_input

%%

file_input:     
  /* empty */               { System.out.println("[OK_] " + $$); }
| file_input file_input_1   { System.out.println("[OK] " + $$); }

file_input_1:
  SALTO
| stmt
;

/* ############################################ */

stmt:
  simple_stmt
| compound_stmt
;

simple_stmt:
  small_stmt SALTO
;

small_stmt:
  expr_stmt
| print_stmt
;

expr_stmt:
  test expr_stmt_1
;
expr_stmt_1:
  /* empty */
| ASIG_OP test
;

print_stmt:
  PRINT test
;

/* ############################################ */

compound_stmt:
  if_stmt
| while_stmt
;

if_stmt:
  IF test SEPARADOR suite if_stmt_1
;
if_stmt_1:
  /* empty */
| ELSE SEPARADOR suite
;

while_stmt:
  WHILE test SEPARADOR suite
;

suite:
  simple_stmt
| SALTO INDENTA stmt suite_1 DEINDENTA
;
suite_1:
  /* empty */
| suite_1 stmt
;

/* ############################################ */

test:
  or_test
;

or_test:
  and_test or_test_1
;
or_test_1:
  /* empty */
| or_test_1 OR and_test
;

and_test:
  not_test and_test_1
;
and_test_1:
  /* empty */
| and_test_1 AND not_test
;

not_test:
  NOT not_test | comparison
;

comparison:
  expr comparison_1
;
comparison_1:
  /* empty */
| comparison_1 comp_op expr
;

comp_op:
  COMP_OP
;

expr:
  term expr_1
;
expr_1:
  /* empty */
| expr_1 EXPR_OP term
;

term:
  factor term_1
;
term_1:
  /* empty */
| term_1 FACTOR_OP factor
;

factor:
  EXPR_OP factor 
| power
;

power:
  atom power_1
;
power_1:
  /* empty */
| POWER_OP factor        
;

atom: 
  IDENTIFICADOR
| ENTERO
| CADENA
| REAL
| BOOLEANO  
| OPEN_PAREN test CLOSE_PAREN
;

%%

private Lexer lexer;

// Regresar átomos
private int yylex() {
  int yyl_return = -1;

  try{
    yyl_return = lexer.yylex();

  }catch (IOException e){
    System.err.println("Error de IO." + e);
  }
  return yyl_return;
}

public void yyerror (String error){
  System.err.println("[ERROR] " +error);
  System.exit(2);
}

public Parser(Reader r){
  lexer = new Lexer(r,this);
}

public static void main(String args[]){
  try{
   Parser yyparser = new Parser(new FileReader(args[0]));
   yyparser.yyparse();
  }catch(FileNotFoundException e){
    System.err.println("El Archivo " + args[0] + " no existe.");
  }

}
