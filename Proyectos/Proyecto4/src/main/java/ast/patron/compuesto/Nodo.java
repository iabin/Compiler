package ast.patron.compuesto;

import ast.patron.visitante.*;

/** 
 * Componente. La clase genérica Nodo.
 */
public class Nodo {

    public enum Tipo {
        INT,
        REAL,
        BOOLEAN,
        STRING;
    }

    Hijos hijos;
    Variable valor;
    Tipo tipo;
    String name;

    public Hijos getHijos() {
	    return hijos;
    }

    public Nodo getHijo() {
	    return null;
    }

    public void setHijo(Nodo c) {

    }

    public Nodo getUltimoHijo() {
	    return hijos.getUltimoHijo();
    }

    public Nodo getPrimerHijo() {
	    return hijos.getPrimerHijo();
    }

    public void agregaHijoFinal(Nodo r) {
        hijos.agregaHijoFinal(r);
    }

    public void agregaHijoPrincipio(Nodo r) {
        hijos.agregaHijoPrincipio(r);
    }

    public Variable getValor() {
	    return valor;
    }

    public Tipo getTipo() {
	    return tipo;
    }

    public String getNombre() {
	    return name;
    }

    public void setNombre(String name) {
        this.name = name;
    }

    public void setValor(Variable nuevo) {
	    valor = nuevo;
    }

    public void setTipo(Tipo nuevo) {
	    tipo = nuevo;
    }

    public void accept(Visitor v) {
     	v.visit(this);
    }

}
