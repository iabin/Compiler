Compilar:
  $ jflex tokens.flex && byaccj -J -Jclass=Parser parser.y && javac Parser.java
Genera Lexer.java, Parser.java, ParserVal.java, y compila todos estos.

Ejecutar:
  $ java Parser <archivo>
Ejemplo: 
  $ java Parser prueba.txt


************
INCISO 4
************
En el método 
  int yyparse()
antes del switch principal, el cual está una línea antes del comentario
  //########## USER-SUPPLIED ACTIONS ##########
agregar
  System.out.println(yyrule[yyn])
para ver la regla con la cual hubo reducción.