[![Build Status](https://travis-ci.org/csdms/bmi-fortran.svg?branch=master)](https://travis-ci.org/csdms/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/csdms/bmi-fortran/badges/version.svg)](https://anaconda.org/csdms/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/csdms/bmi-fortran/badges/platforms.svg)](https://anaconda.org/csdms/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/csdms/bmi-fortran/badges/installer/conda.svg)](https://conda.anaconda.org/csdms)
[![Anaconda-Server Badge](https://anaconda.org/csdms/bmi-fortran/badges/downloads.svg)](https://anaconda.org/csdms/bmi-fortran)

# bmi-fortran

Bindings, created with Fortran 2003,
for the CSDMS [Basic Model Interface](https://bmi-spec.readthedocs.io).


## Build/Install

To build the BMI Fortran bindings from source with cmake, run

    mkdir _build && cd _build
    cmake .. -DCMAKE_INSTALL_PREFIX=<path-to-installation>
    make

where `<path-to-installation>` is the base directory
in which to install the bindings (`/usr/local` is the default).

Then, to install:

    make install

The installation will look (on Linux) like:

```bash
.
|-- include
|   `-- bmif.mod
`-- lib
    `-- libbmif.so
```

Alternately,
[conda binaries](https://anaconda.org/csdms/bmi-fortran)
have been built for Linux and macOS.
Install the Fortran BMI bindings (no build needed)
into an Anaconda distribution with

    conda install bmi-fortran -c csdms


## Use

To write a BMI for a model,
`use` the `bmif` module and implement all the BMI procedures
included in the interface defined in `bmif`.
A sample implementation is given in the
https://github.com/csdms/bmi-example-fortran
repository.


## Note

For a Fortran BMI that uses Fortran 90/95,
see https://github.com/csdms/bmi-f90.

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
for users who aren't comfortable
the object-oriented features of Fortran 2003.
Further, both BMI implementations are backward-compatible with Fortran 77.
All that is needed is a compiler that's capable of handling
the more recent versions of Fortran;
for example `gfortran` in the GNU Compiler Collection.
