all:
	rm -rf ./out
	mkdir out
	jflex src/main/jflex/*.flex -d ./
	/usr/local/bin/yacc.macosx -v -Jclass=Parser src/main/byaccj/*.y
	mv *.java* y.output ./out
	cd ./out && javac Parser.java 

test:
	cd ./out && java Parser ../${file}

clean:
	rm -rf ./out
