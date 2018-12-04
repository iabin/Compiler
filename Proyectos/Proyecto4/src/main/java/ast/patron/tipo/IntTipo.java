package ast.patron.tipo;

import ast.patron.compuesto.Variable;

public class IntTipo extends Tipo {

	public BooleanTipo add(BooleanTipo b) {
		return b.add(this);
	}

	public IntTipo add(IntTipo i) {
		IntTipo res = new IntTipo();
		res.setVal(new Variable(val.ival + i.getVal().ival));
		return res;
	}

	public RealTipo add(RealTipo r) {
		RealTipo res = new RealTipo();
		res.setVal(new Variable(val.ival + r.getVal().dval));
		return res;
	}

	public StringTipo add(StringTipo s) {
		StringTipo res = new StringTipo();
		res.setVal(new Variable(val.ival + s.getVal().sval));
		return res;
	}

}