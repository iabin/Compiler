package ast.patron.tipo;

import ast.patron.compuesto.Variable;

public class StringTipo extends Tipo {

	public BooleanTipo add(BooleanTipo b) {
		return b.add(this);
	}

	public StringTipo add(IntTipo i) {
		return i.add(this);
	}

	public StringTipo add(RealTipo r) {
		return r.add(this);
	}

	public StringTipo add(StringTipo s) {
		StringTipo res = new StringTipo();
		res.setVal(new Variable(val.sval + s.getVal().sval));
		return res;
	}

}