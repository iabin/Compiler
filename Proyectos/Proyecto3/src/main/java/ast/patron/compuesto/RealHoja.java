package ast.patron.compuesto;

import ast.patron.visitante.*;

public class RealHoja extends Hoja {
	
    public RealHoja(double d) {
		valor = new Variable(d);
		tipo = Tipos.REAL;
    }
    
}
