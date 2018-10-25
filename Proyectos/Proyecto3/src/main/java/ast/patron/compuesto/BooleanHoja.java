package ast.patron.compuesto;

import ast.patron.visitante.*;

public class BooleanHoja extends Hoja {
	
    public BooleanHoja(boolean b) {
		valor = new Variable(b);
		tipo = Tipo.BOOLEAN;
    }

    public void accept(Visitor v) {
     	v.visit(this);
    }

}
