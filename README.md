[![Build Status](https://travis-ci.org/csdms/bmi-fortran.svg?branch=master)](https://travis-ci.org/csdms/bmi-fortran)

# bmi-fortran

Fortran bindings, created with Fortran 2003, for the
[Basic Model Interface](http://csdms.colorado.edu/wiki/BMI_Description).

## Build

To build the BMI Fortran bindings, sample implementation, and tests, execute

    $ mkdir _build && cd _build
    $ cmake .. -DCMAKE_INSTALL_PREFIX=<path-to-installation>
    $ make

where `<path-to-installation>` is the base directory where you want
to install things (`/usr/local` is the default).

## Test

Run some simple tests with

    $ make test

## Install

To install:

    $ make install
