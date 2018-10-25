package ast.patron.visitante;
import ast.patron.compuesto.*;

public interface Visitor
{
    public void visit(IntHoja n);
    public void visit(RealHoja n);
    public void visit(StringHoja n);
    public void visit(BooleanHoja n);
    public void visit(Nodointerno n);
}
