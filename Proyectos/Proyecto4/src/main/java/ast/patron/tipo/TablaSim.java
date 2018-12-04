package ast.patron.tipo;

import java.util.Hashtable;
import ast.patron.compuesto.Variable;


public class TablaSim {

	private static final Hashtable<String, Variable> TABLA;

	static {
		TABLA = new Hashtable<>();
	}

	public static Variable lookup(String name) {
		return TABLA.getOrDefault(name, null);
	}

	public static Variable insert(String name, Variable info) {
		return TABLA.put(name, info);
	}

}