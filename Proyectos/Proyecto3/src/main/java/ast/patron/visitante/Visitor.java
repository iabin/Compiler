package ast.patron.visitante;
import ast.patron.compuesto.*;

public interface Visitor
{
    public void visit(IntHoja n);
    public void visit(Nodo n);
}
