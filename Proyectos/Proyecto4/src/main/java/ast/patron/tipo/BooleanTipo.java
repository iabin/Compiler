package ast.patron.tipo;

import ast.patron.compuesto.Variable;

public class BooleanTipo extends Tipo {

	public BooleanTipo add(BooleanTipo b) {
		BooleanTipo r = new BooleanTipo();
		r.setVal(new Variable(val.bval || b.getVal().bval));
		return r;
	}

	public BooleanTipo add(IntTipo i) {
		boolean o = i.getVal().ival != 0;
		BooleanTipo r = new BooleanTipo();
		r.setVal(new Variable(val.bval || o));
		return r;
	}

	public BooleanTipo add(StringTipo s) {
		boolean o = Boolean.parseBoolean(s.getVal().sval);
		BooleanTipo r = new BooleanTipo();
		r.setVal(new Variable(val.bval || o));
		return r;
	}

	public BooleanTipo add(RealTipo r) {
		boolean o = r.getVal().dval != 0;
		BooleanTipo res = new BooleanTipo();
		res.setVal(new Variable(val.bval || o));
		return res;
	}

}