aws_options  = -m -c -d -n -w -3 -k


all: web

queens.c: ../../aws_sources/all_parts/queens_complete.aws
	../../../aws2c $(aws_options) -f config.h ../../aws_sources/all_parts/queens_complete.aws queens.c


all_parts: queens.c inout.c loadsave.c
	emcc -DCONFIG_FILENAME=\"config.h\" queens.c inout.c loadsave.c terminal.c -o game.html -sEXPORTED_FUNCTIONS=_main -sEXPORTED_RUNTIME_METHODS=ccall,cwrap -s EXPORT_ES6=1 -s ASYNCIFY -O2
	cat preamble.js game.js >temp.js
	rm game.js
	mv temp.js game.js  
	cp *.js /Users/davidebucci/Sites/queens_footsteps
	cp *.wasm /Users/davidebucci/Sites/queens_footsteps
	cp queens_footsteps.html /Users/davidebucci/Sites/queens_footsteps
	cp queens_footsteps.html /Users/davidebucci/Sites/queens_footsteps/index.html
	cp *.jpg /Users/davidebucci/Sites/queens_footsteps

web: all_parts

clean:
	rm queens.c config.h config1.h config2.h config34.h *.o queens.js *.wasm