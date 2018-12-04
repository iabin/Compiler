package ast.patron.compuesto;

import ast.patron.visitante.*;

public class RealHoja extends Hoja {
	
    public RealHoja(double d) {
		valor = new Variable(d);
		tipo = Tipo.REAL;
    }
    
    public void accept(Visitor v) {
     	v.visit(this);
    }
    
}
