package ast.patron.compuesto;

import ast.patron.visitante.*;

public class StringHoja extends Hoja {
	
    public StringHoja(String s) {
		valor = new Variable(s);
		tipo = Tipo.STRING;
    }

    public void accept(Visitor v) {
     	v.visit(this);
    }
    
}
