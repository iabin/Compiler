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
    | stmt { $$ = new NodoInterno($1); $$.setNombre("stmt"); }
    | aux0 SALTO { $$ = $1; }
    | aux0 stmt { $$ = $1; $1.agregaHijoPrincipio($2); }
;

/*    stmt: simple_stmt | compound_stmt*/
stmt: simple_stmt {$$ = $1;}
    | compound_stmt { $$ = $1; }
;

/* compound_stmt: if_stmt | while_stmt */
compound_stmt: if_stmt { $$ = $1; }
             | while_stmt { $$ = $1; }
;

/* if_stmt: 'if' test ':' suite ['else' ':' suite] */
if_stmt:  
  IF test DOBLEPUNTO suite ELSE DOBLEPUNTO suite 
    {
      $$ = new NodoInterno();
      $$.setNombre("if");
      $$.agregaHijoFinal($2);
      $$.agregaHijoFinal($4);
      $$.agregaHijoFinal($7);
    }
  | IF test DOBLEPUNTO suite 
    {
      $$ = new NodoInterno();
      $$.setNombre("if");
      $$.agregaHijoFinal($2);
      $$.agregaHijoFinal($4);
    }
;

/*    while_stmt: 'while' test ':' suite */
while_stmt: WHILE test DOBLEPUNTO suite {
      $$ = new NodoInterno();
      $$.setNombre("while");
      $$.agregaHijoFinal($2);
      $$.agregaHijoFinal($4);
    }
;

/*    suite: simple_stmt | SALTO INDENTA stmt+ DEINDENTA */
suite: simple_stmt {$$ = $1;}
     | SALTO INDENTA auxstmt DEINDENTA {$$ = $3;}
;

/*    auxstmt:  stmt+ */
auxstmt: stmt { $$ = new NodoInterno($1); $$.setNombre("stmt"); }
       | auxstmt stmt { $$ = $1; $1.agregaHijoFinal($2); }
;

/* simple_stmt: small_stmt SALTO */
simple_stmt: small_stmt SALTO {$$ = $1;}
;

/* small_stmt: expr_stmt | print_stmt  */
small_stmt: expr_stmt {$$ = $1;}
          | print_stmt { $$ = $1; }
;

/* expr_stmt: test ['=' test] */
expr_stmt: test {$$ = $1;}
         | test EQ test { 
            $$ = new NodoInterno(); 
            $$.setNombre("asig");
            $$.agregaHijoFinal($1); 
            $$.agregaHijoFinal($3); }
;

/* print_stmt: 'print' test  */
print_stmt: PRINT test {$$ = new NodoInterno(); 
            $$.setNombre("print");
            $$.agregaHijoFinal($2); }
;

/*   test: or_test */
test: or_test {$$ = $1;}
;

/*    or_test: (and_test 'or')* and_test  */
or_test: and_test {$$ = $1;}
       | aux2 and_test { $$ = $1; $$.agregaHijoFinal($2); }
;
/*    aux2: (and_test 'or')+  */
aux2: and_test OR {$$ = new NodoInterno(); 
            $$.setNombre("or");
            $$.agregaHijoFinal($1); }
    | aux2 and_test OR {$$ = new NodoInterno(); 
            $$.setNombre("or");
            $$.agregaHijoFinal($2); $$.agregaHijoFinal($3);}
;

/*    and_expr: (not_test 'and')* not_test */
and_test: not_test {$$ = $1;}
        | aux7 not_test { $$ = $1; $$.agregaHijoFinal($2); }
;

/*    and_expr: (not_test 'and')+ */
aux7: not_test AND {$$ = new NodoInterno(); 
            $$.setNombre("and");
            $$.agregaHijoFinal($1); }
    | aux7 not_test AND { $$ = $1; $3.agregaHijoFinal($2); $$.agregaHijoFinal($3); }
;

/*    not_test: 'not' not_test | comparison */
not_test: NOT not_test {$$ = new NodoInterno(); 
            $$.setNombre("not");
            $$.agregaHijoFinal($2);}
        | comparison {$$ = $1;}
;

/*    comparison: (expr comp_op)* expr  */
comparison: expr {$$ = $1;}
          | aux4 expr { $$ = $1; $$.agregaHijoFinal($2); }
;

/*    aux4: (expr comp_op)+  */
aux4: expr comp_op { $$ = $2; $$.agregaHijoFinal($1); }
    | aux4 expr comp_op {$$ = $1; $3.agregaHijoFinal($2); $$.agregaHijoFinal($3);}
;

/*    comp_op: '<'|'>'|'=='|'>='|'<='|'!=' */
comp_op: LE { $$ = new NodoInterno(); $$.setNombre("le"); }
       | GR {$$ = new NodoInterno(); $$.setNombre("gr"); }
       | EQUALS {$$ = new NodoInterno(); $$.setNombre("equals"); }
       | GRQ {$$ = new NodoInterno(); $$.setNombre("grq"); }
       | LEQ {$$ = new NodoInterno(); $$.setNombre("leq"); }
       | DIFF {$$ = new NodoInterno(); $$.setNombre("diff"); }
;

/*    expr: (term ('+'|'-'))* term   */
expr: term {$$ = $1;}
    | aux8 term {$$ = $1; $$.agregaHijoFinal($2); }
;
aux8: term MAS {$$ = new NodoInterno(); $$.setNombre("add"); $$.agregaHijoFinal($1); }
    | term MENOS {$$ = new NodoInterno(); $$.setNombre("diff"); $$.agregaHijoFinal($1);}
    | aux8 term MAS {$$ = new NodoInterno(); $$.setNombre("add"); $$.agregaHijoFinal($1); $1.agregaHijoFinal($2);}
    | aux8 term MENOS {$$ = new NodoInterno(); $$.setNombre("diff"); $$.agregaHijoFinal($1);$1.agregaHijoFinal($2);}
;

/*   term: (factor ('*'|'/'|'%'|'//'))* factor   */
term: factor {$$ = $1;}
    | aux9 factor {$$ = $1; $$.agregaHijoFinal($2);}
;
aux9: factor POR {$$ = new NodoInterno(); $$.setNombre("por"); $$.agregaHijoFinal($1);}
    | factor DIVENTERA {$$ = new NodoInterno(); $$.setNombre("diventera"); $$.agregaHijoFinal($1);}
    | factor MODULO {$$ = new NodoInterno(); $$.setNombre("modulo"); $$.agregaHijoFinal($1);}
    | factor DIV {$$ = new NodoInterno(); $$.setNombre("div"); $$.agregaHijoFinal($1);}
    | aux9 factor POR {$$ = new NodoInterno(); $$.setNombre("por"); $$.agregaHijoFinal($1);$1.agregaHijoFinal($2);}
    | aux9 factor DIVENTERA {$$ = new NodoInterno(); $$.setNombre("diventera"); $$.agregaHijoFinal($1);$1.agregaHijoFinal($2);}
    | aux9 factor MODULO {$$ = new NodoInterno(); $$.setNombre("modulo"); $$.agregaHijoFinal($1);$1.agregaHijoFinal($2);}
    | aux9 factor DIV {$$ = new NodoInterno(); $$.setNombre("div"); $$.agregaHijoFinal($1);$1.agregaHijoFinal($2);}
;
/* factor: ('+'|'-') factor | power */
factor: MAS factor {$$ = new NodoInterno(); $$.setNombre("add"); $$.agregaHijoFinal($1);}
      | MENOS factor {$$ = new NodoInterno(); $$.setNombre("diff"); $$.agregaHijoFinal($1);}
      | power {$$ = $1;}
;
/* power: atom ['**' factor] */
power:  atom {$$ = $1;}
      | atom POTENCIA factor {$$ = new NodoInterno(); $$.setNombre("potencia"); $$.agregaHijoFinal($1);$$.agregaHijoFinal($3);}
;

/* atom: IDENTIFICADOR | ENTERO | CADENA | REAL | BOOLEANO | '(' test ')' */
atom:  IDENTIFICADOR {$$ = $1;}
     | ENTERO {$$ = $1;}
     | CADENA {$$ = $1;}
     | REAL {$$ = $1;}
     | BOOLEANO {$$ = $1;}
     | PA test PC {$$ = $2;}
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
