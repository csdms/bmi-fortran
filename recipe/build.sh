#! /usr/bin/env bash

mkdir _build && cd _build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make
make install

# Why are Fortran .mod files being compressed?
if [[ `uname -s` == 'Linux' ]]; then
    cd $PREFIX/lib
    mod_files=`ls -1 *.mod`
    for f in $mod_files; do
	mv $f $f.gz
	gunzip $f.gz
    done
fi
