package ast.patron.tipo;

import ast.patron.compuesto.Variable;

public class RealTipo extends Tipo {

	public BooleanTipo add(BooleanTipo b) {
		return b.add(this);
	}

	public RealTipo add(IntTipo i) {
		return i.add(this);
	}

	public RealTipo add(RealTipo r) {
		RealTipo res = new RealTipo();
		res.setVal(new Variable(val.dval + r.getVal().dval));
		return res;
	}

	public StringTipo add(StringTipo s) {
		StringTipo res = new StringTipo();
		res.setVal(new Variable(val.dval + s.getVal().sval));
		return res;
	}

}