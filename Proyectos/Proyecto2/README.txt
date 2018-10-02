Compilar lexer.flex, parser.y, y los .java generados:
    $ make all

El archivo makefile tiene dos propiedades:
    jflex_bin := jflex
    byaccj_bin := byaccj
Por si tus binarios no se llaman jflex y byaccj.

Para probar un archivo, meterlo al directorio tests y:
    $ make test file=<archivo>

Por ejemplo:
    $ make test file=test.txt