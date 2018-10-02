jflex_bin := jflex
byaccj_bin := byaccj

all:
	rm -rf ./out
	mkdir out 
	$(jflex_bin) src/main/jflex/lexer.flex -d ./
	$(byaccj_bin) -v -Jclass=Parser src/main/byaccj/parser.y
	mv *.java* y.output ./out
	cd ./out && javac Parser.java 

test:
	cd ./out && java Parser ../tests/${file}

clean:
	rm -rf ./out
