package lexico;

import java.io.File;
import java.io.FileInputStream;
import java.io.Reader;
import java.io.InputStreamReader;
import java.io.FileWriter;

public class Main {
	public static void main(String[] args) {
		if (args.length == 0) {
			System.err.println("No se especificaron archivos de entrada.");
			System.exit(1);
		}

		for (String nombre: args) {
			try {
				File archivo = new File(nombre);
				FileInputStream stream = new FileInputStream(nombre);
      			Reader reader = new InputStreamReader(stream, "UTF-8");

      			(new File("out")).mkdir();
      			String nuevoNombre = (archivo.getName().contains(".")) ? 
      				archivo.getName().substring(0, archivo.getName().lastIndexOf(".")) : archivo.getName();
      			File nuevoArchivo = new File("out/" + nuevoNombre + ".plx");
      			FileWriter writer = new FileWriter(nuevoArchivo);

      			Flexer scanner = new Flexer(reader, writer);
      			while (!scanner.getZzAtEOF()) {
      				scanner.yylex();
      			}
      			writer.close();
      			System.out.println(nuevoArchivo.getAbsolutePath());
			} catch (java.io.FileNotFoundException e) {
				System.err.println("No existe el archivo \"" + nombre + "\".");
			} catch (java.io.IOException e) {
				System.err.println("Error al leer el archivo \"" + nombre + "\".");
			} catch (Exception e) {
				System.err.println("Error inesperado con el archivo \"" + nombre + "\".");
			}
		}
	}
}
