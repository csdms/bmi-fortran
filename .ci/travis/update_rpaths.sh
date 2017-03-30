#!/usr/bin/env bash

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then

    executables="irf_test \
        conflicting_instances_test \
	get_value_test \
        info_test \
	set_value_test \
        vargrid_test"

    for exe in $executables; do
	install_name_tool \
	    -change @rpath/libgfortran.3.dylib \
	            ${CONDA_PREFIX}/lib/libgfortran.3.dylib \
	    -change @rpath/libquadmath.0.dylib \
	            ${CONDA_PREFIX}/lib/libquadmath.0.dylib \
	    ./testing/$exe
	echo "Updated $exe"
    done

fi
