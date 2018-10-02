Compilar: 
  $ mvn package
Esto ejecutará el plugin de jflex para transformar la gramática
definida en src/main/jflex/Flexer.jflex en src/main/java/lexico/Flexer.java.
También compilará las clases de Java y creará el archivo target/lexico-1.0-SNAPSHOT.jar.

Ejecutar:
  $  java -jar target/lexico-1.0-SNAPSHOT.jar <archivo(s)>
Ejemplo:
  $  java -jar target/lexico-1.0-SNAPSHOT.jar ejemplos/*

Los archivos de salida se guardan en el directorio out con el mismo nombre
pero la extensión .plx.
Si no existe el directorio out, se creará en tiempo de ejecución.