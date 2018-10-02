[![Build Status](https://travis-ci.org/csdms/bmi-fortran.svg?branch=master)](https://travis-ci.org/csdms/bmi-fortran)

# bmi-fortran

Fortran bindings, created with Fortran 2003, for the
[Basic Model Interface](http://csdms.colorado.edu/wiki/BMI_Description).

The bindings are defined in the [bmi](./bmi) directory.
A sample implementation is provided in the [heat](./heat) directory.

## Build

To build the BMI Fortran bindings, sample implementation, tests,
and examples, execute

    $ mkdir _build && cd _build
    $ cmake .. -DCMAKE_INSTALL_PREFIX=<path-to-installation>
    $ make

where `<path-to-installation>` is the base directory where you want
to install things (`/usr/local` is the default).

## Install

To install:

    $ make install


On macOS, update runtime paths after install with

    $ source ../scripts/update_rpaths

## Test

Run some simple unit tests on the sample implementation with

    $ ctest

## Note

Why two different Fortran BMIs?
Though Fortran 90/95 has the concept of an interface,
it doesn't allow procedures to be included within types.
This is difficult to reconcile with BMI, which, in Fortran,
would ideally be implemented as a collection of procedures in a type.
Thus, the Fortran 90/95 BMI is set up as an example
that a user can copy and modify,
substituting their code for code in the example.
This is somewhat cumbersome.
The Fortran 2003 BMI implementation acts a true interface--it can be imported
as a type from a module into a Fortran program and its methods overridden.
The CSDMS IF software engineers recommend using the Fortran 2003 bindings;
however, we will continue to support the Fortran 90/95 bindings
for users in the CSDMS community who aren't comfortable
using the object-oriented features of Fortran 2003.
Further, both BMI implementations are backward-compatible with Fortran 77.
All that is needed is a compiler that's capable of handling
the more recent versions of Fortran;
for example `gfortran` in the GNU Compiler Collection.
