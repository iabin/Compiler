package ast.patron.compuesto;

import ast.patron.visitante.*;

public class IntHoja extends Hoja {
	
    public IntHoja(int i) {
		valor = new Variable(i);
		tipo = Tipo.INT;
    }

    public void accept(Visitor v) {
     	v.visit(this);
    }

}
