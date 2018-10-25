# Proyecto 3

Generación del AST con el patrón _compuesto_.

## Compilar
`mvn clean initialize compile`

## Ejecutar
`mvn exec:java -Dexec.mainClass="ast.Compilador"`

## Generación de documentación
El pom incluye un plugin que es un wrapper de doxygen
https://github.com/os-cillation/doxygen-maven-plugin .

Para usarlo tiene que tener instalado _doxygen_ y, de manera recomendada,
la biblioteca _graphviz_ .

`mvn doxygen:generate`