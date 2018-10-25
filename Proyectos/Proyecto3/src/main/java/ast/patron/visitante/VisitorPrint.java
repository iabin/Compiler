package ast.patron.visitante;
import ast.patron.compuesto.*;
import java.util.LinkedList;
import java.util.Iterator;

public class VisitorPrint implements Visitor
{

    public void visit(IntHoja n){
	System.out.print("[Hoja Entera] valor: " + n.getValor().ival);
    }

    public void visit(Nodo n){

    }

}
