package ast.patron.compuesto;

import ast.patron.visitante.*;

public class Hoja extends Nodo {

    public void accept(Visitor v) {
     	v.visit(this);
    }

}
