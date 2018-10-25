package ast.patron.compuesto;

public class Variable {

    /**
     * integer value of this 'union'
     */
    public int ival;

    /**
     * boolean value of this 'union'
     */
    public boolean bval;

    /**
     * double value of this 'union'
     */
    public double dval;

    /**
     * string value of this 'union'
     */
    public String sval;

    /**
     * object value of this 'union'
     */
    public Object obj;

    /**
     * Initialize me without a value
     */
    public Variable() {}

    /**
     * Initialize me as a boolean
     */
    public Variable(boolean val) {
        bval=val;
    }

    /**
     * Initialize me as an int
     */
    public Variable(int val) {
        ival=val;
    }

    /**
     * Initialize me as a double
     */
    public Variable(double val) {
        dval=val;
    }

    /**
     * Initialize me as a string
     */
    public Variable(String val) {
        sval=val;
    }

    /**
     * Initialize me as an Object
     */
    public Variable(Object val) {
        obj=val;
    }

}