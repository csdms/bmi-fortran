[![Build Status](https://travis-ci.org/csdms/bmi-fortran.svg?branch=master)](https://travis-ci.org/csdms/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/version.svg)](https://anaconda.org/conda-forge/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/platforms.svg)](https://anaconda.org/conda-forge/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/downloads.svg)](https://anaconda.org/conda-forge/bmi-fortran)

# bmi-fortran

The Fortran specification, created with Fortran 2003,
for the CSDMS [Basic Model Interface](https://bmi-spec.readthedocs.io).


## Build/Install

The Fortran BMI bindings can be built on Linux, macOS, and Windows.
Instructions are given below.

**Prerequisites:**
* A Fortran compiler
* CMake

Alternately,
[conda binaries](https://anaconda.org/conda-forge/bmi-fortran)
have been built for Linux, macOS, and Windows.
Install the Fortran BMI bindings (no build needed)
into an Anaconda distribution with

    conda install bmi-fortran -c conda-forge

### Linux and macOS

To build the Fortran BMI bindings from source with cmake, run

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
|   `-- bmif_1_2.mod
`-- lib
    |-- libbmif.so -> libbmif.so.1.2
    `-- libbmif.so.1.2
```

### Windows

An additional prerequisite is needed for Windows:

* Microsoft Visual Studio 2017 or Microsoft Build Tools for Visual Studio 2017

To configure the Fortran BMI bindings from source with cmake,
run the following in a [Developer Command Prompt](https://docs.microsoft.com/en-us/dotnet/framework/tools/developer-command-prompt-for-vs)

    mkdir _build && cd _build
    cmake .. ^
	  -G "NMake Makefiles" ^
	  -DCMAKE_INSTALL_PREFIX=<path-to-installation> ^
	  -DCMAKE_BUILD_TYPE=Release

where `<path-to-installation>` is the base directory
in which to install the bindings (`"C:\Program Files (x86)"` is the default;
note that quotes and an absolute path are needed).

Then, to build and install:

	cmake --build . --target install --config Release


## Use

To write a BMI for a model,
`use` the `bmif_1_2` module and implement all the BMI procedures
included in the interface defined therein.
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
