package ast.patron.compuesto;

import ast.patron.visitante.*;

public class NodoInterno extends Nodo {
	
	public NodoInterno(){}

    public NodoInterno(Object o) {
		valor = new Variable(o);
    }

    public void accept(Visitor v) {
     	v.visit(this);
    }

}
