#!/usr/bin/env bash

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then

    examples="irf_ex \
        conflicting_instances_ex \
	get_value_ex \
        info_ex \
	set_value_ex \
        vargrid_ex"

    for exe in $examples; do
	install_name_tool \
	    -change @rpath/libgfortran.3.dylib \
	            ${CONDA_PREFIX}/lib/libgfortran.3.dylib \
	    -change @rpath/libquadmath.0.dylib \
	            ${CONDA_PREFIX}/lib/libquadmath.0.dylib \
	    ./heat/examples/$exe
	echo "Updated $exe"
    done

fi
