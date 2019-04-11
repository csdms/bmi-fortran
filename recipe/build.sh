#! /usr/bin/env bash

mkdir _build && cd _build
cmake .. -DCMAKE_INSTALL_PREFIX=$PREFIX
make
make install

# Why are Fortran .mod files being compressed by conda-build?
if [[ `uname -s` == 'Linux' ]]; then
    cd $PREFIX/include
    f=bmif.mod
    mv $f $f.gz
    gunzip $f.gz
fi
