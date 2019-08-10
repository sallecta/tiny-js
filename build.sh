#!/bin/bash
build="ignore/build"
#debug version: compile="g++ -c -g -Wall -rdynamic -D_DEBUG"
compile="g++ -c -g -Wall -rdynamic"
copileAndLink="g++ -g -rdynamic"

if [ -d "$build" ]; then rm -Rf $build; fi
if [ ! -d "$build" ]; then mkdir -p $build; fi

step=0
objects=""

func_make_obj () {
	step=$(($step + 1))
	steptarget=$1
	if [ "$2" == "" ]; then targetdir=""; else targetdir="$2/"; fi
	objects=$objects" $build/$steptarget.o"
	echo "$step. make_obj: $steptarget"
	$compile $targetdir$steptarget.cpp -o $build/$steptarget.o
}
func_make_exe () {
	step=$(($step + 1))
	steptarget=$1
	if [ "$2" == "" ]; then targetdir=""; else targetdir="$2/"; fi
	echo "$step. make_exe: $steptarget"
	$copileAndLink $targetdir$steptarget.cpp $objects -o $build/$steptarget
}
func_final () {
	step=$(($step + 1))
	steptarget=$1
	echo "$step. final: removing object files"
	rm $build/*.o
	echo "Build complete."
}

func_make_obj "tinyjs" "src"

func_make_obj "tinyjs-functions" "src"

func_make_obj "tinyjs-functions-math" "src"

func_make_exe "run_tests" "src"

func_make_exe "script" "src"

func_final

