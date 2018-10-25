%{
  import ast.patron.compuesto.*;
  import java.lang.Math;
  import java.io.*;
%}
/* Átomos del lenguaje */
%token CADENA
%token SALTO IDENTIFICADOR ENTERO REAL
%token BOOLEANO DEINDENTA INDENTA
%token AND OR NOT WHILE
%token FOR PRINT ELIF ELSE IF
%token MAS MENOS POR POTENCIA DIV  /* + | - | * | ** | / */
%token DIVENTERA MODULO LE GR LEQ /* // | % | < | > | <= */
%token GRQ EQUALS DIFF EQ PA /* >= | == | != | = | ( */
%token PC DOBLEPUNTO /* ) | : | ; */

/* Producciones */
%%
/*    input: (SALTO | stmt)* ENDMARKER */
input:      {raíz = $$; System.out.println("Reconocimiento Exitoso");}
     | aux0 {raíz = $1; System.out.println("Reconocimiento Exitoso");}
;

/*    aux0: (SALTO | stmt)+ */
aux0: SALTO
    | stmt {$$ = $1;}
    | aux0 SALTO {}
    | aux0 stmt {}
;

/*    stmt: simple_stmt | compound_stmt*/
stmt: simple_stmt {$$ = $1;}
    | compound_stmt {}
;

/* compound_stmt: if_stmt | while_stmt */
compound_stmt: if_stmt {}
             | while_stmt {}
;

/* if_stmt: 'if' test ':' suite ['else' ':' suite] */
if_stmt:  IF test DOBLEPUNTO suite ELSE DOBLEPUNTO suite {}
        | IF test DOBLEPUNTO suite {}
;

/*    while_stmt: 'while' test ':' suite */
while_stmt: WHILE test DOBLEPUNTO suite {}
;

/*    suite: simple_stmt | SALTO INDENTA stmt+ DEINDENTA */
suite: simple_stmt {$$ = $1;}
     | SALTO INDENTA auxstmt DEINDENTA {$$ = $3;}
;

/*    auxstmt:  stmt+ */
auxstmt: stmt {}
       | auxstmt stmt {}
;

/* simple_stmt: small_stmt SALTO */
simple_stmt: small_stmt SALTO {$$ = $1;}
;

/* small_stmt: expr_stmt | print_stmt  */
small_stmt: expr_stmt {$$ = $1;}
          | print_stmt {}
;

/* expr_stmt: test ['=' test] */
expr_stmt: test {$$ = $1;}
         | test EQ test {}
;

/* print_stmt: 'print' test  */
print_stmt: PRINT test {}
;

/*   test: or_test */
test: or_test {$$ = $1;}
;

/*    or_test: (and_test 'or')* and_test  */
or_test: and_test {$$ = $1;}
       | aux2 and_test {}
;
/*    aux2: (and_test 'or')+  */
aux2: and_test OR {}
    | aux2 and_test OR {}
;

/*    and_expr: (not_test 'and')* not_test */
and_test: not_test {$$ = $1;}
        | aux7 not_test {}
;

/*    and_expr: (not_test 'and')+ */
aux7: not_test AND {}
    | aux7 not_test AND {}
;

/*    not_test: 'not' not_test | comparison */
not_test: NOT not_test {}
        | comparison {$$ = $1;}
;

/*    comparison: (expr comp_op)* expr  */
comparison: expr {$$ = $1;}
          | aux4 expr {}
;

/*    aux4: (expr comp_op)+  */
aux4: expr comp_op {}
    | aux4 expr comp_op {}
;

/*    comp_op: '<'|'>'|'=='|'>='|'<='|'!=' */
comp_op: LE {}
       | GR {}
       | EQUALS {}
       | GRQ {}
       | LEQ {}
       | DIFF {}
;

/*    expr: (term ('+'|'-'))* term   */
expr: term {$$ = $1;}
    | aux8 term {}
;
aux8: term MAS {}
    | term MENOS {}
    | aux8 term MAS {}
    | aux8 term MENOS {}
;

/*   term: (factor ('*'|'/'|'%'|'//'))* factor   */
term: factor {$$ = $1;}
    | aux9 factor {}
;
aux9: factor POR {}
    | factor DIVENTERA {}
    | factor MODULO {}
    | factor DIV {}
    | aux9 factor POR {}
    | aux9 factor DIVENTERA {}
    | aux9 factor MODULO {}
    | aux9 factor DIV {}
;
/* factor: ('+'|'-') factor | power */
factor: MAS factor {}
      | MENOS factor {}
      | power {$$ = $1;}
;
/* power: atom ['**' factor] */
power:  atom {$$ = $1;}
      | atom POTENCIA factor {}
;

/* atom: IDENTIFICADOR | ENTERO | CADENA | REAL | BOOLEANO | '(' test ')' */
atom:  IDENTIFICADOR {}
     | ENTERO {$$ = $1;}
     | CADENA {}
     | REAL {}
     | BOOLEANO {}
     | PA test PC {}
;
%%
private Flexer lexer;
/* Nodo Raiz del AST */
public Nodo raíz;

/* Comunicación con el analizador léxico */
private int yylex () {
    int yyl_return = -1;
    try {
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
}

/* Reporta errores y para ejecución. */
public void yyerror (String error) {
   System.err.println ("Error sintáctico en la línea " + lexer.line());
   System.exit(1);
}

/* lexer es creado en el constructor. */
public Parser(Reader r) {
    lexer = new Flexer(r, this);
    yydebug = true;
}
