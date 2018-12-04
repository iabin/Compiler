package ast.patron.visitante;
import ast.patron.compuesto.*;
import java.util.LinkedList;
import java.util.Iterator;

public class VisitorPrint implements Visitor {

    public void visit(IntHoja n) {
		System.out.print("[Hoja Entera] valor: " + n.getValor().ival);
    }

    public void visit(RealHoja n) {
		System.out.print("[Hoja real] valor: " + n.getValor().dval);
    }

    public void visit(StringHoja n) {
		System.out.print("[Hoja cadena] valor: " + n.getValor().sval);
    }

    public void visit(BooleanHoja n) {
		System.out.print("[Hoja booleana] valor: " + n.getValor().bval);
    }

    public void visit(Nodo n) {
    	System.out.print("[Nodo interno] " + n.getNombre());
    	for (Nodo nH: n.getHijos().getAll()) {
    		visit(nH);
    	}
    }

}
