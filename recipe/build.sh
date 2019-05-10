#! /usr/bin/env bash

mkdir _build && cd _build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make
make install

# Why are Fortran .mod files being compressed by conda-build?
if [[ `uname -s` == 'Linux' ]]; then
    cd $PREFIX/include
    mod_files=`ls -1 bmif*.mod`
    for f in $mod_files; do
	mv $f $f.gz
	gunzip $f.gz
    done
fi
