#!/bin/bash
build="ignore/build"
#debug version: compile="g++ -c -g -Wall -rdynamic -D_DEBUG"
compile="g++ -c -g -Wall -rdynamic"
copileAndLink="g++ -g -rdynamic"

if [ -d "$build" ]; then rm -Rf $build; fi
if [ ! -d "$build" ]; then mkdir $build; fi

step=0
objects=""

func_make_obj () {
	step=$(($step + 1))
	steptarget=$1
	objects=$objects" $build/$steptarget.o"
	echo "$step. make_obj: $steptarget"
	$compile $steptarget.cpp -o $build/$steptarget.o
}
func_make_exe () {
	step=$(($step + 1))
	steptarget=$1
	echo "$step. make_exe: $steptarget"
	$copileAndLink $steptarget.cpp $objects -o $build/$steptarget
}
func_final () {
	step=$(($step + 1))
	steptarget=$1
	echo "$step. final: removing object files"
	rm $build/*.o
	echo "Build complete."
}

func_make_obj "tinyjs"

func_make_obj "tinyjs-functions"

func_make_obj "tinyjs-functions-math"

func_make_exe "run_tests"

func_make_exe "script"

func_final

