[![DOI](https://zenodo.org/badge/84101233.svg)](https://zenodo.org/badge/latestdoi/84101233)
[![Build and Test](https://github.com/csdms/bmi-fortran/actions/workflows/test.yml/badge.svg)](https://github.com/csdms/bmi-fortran/actions/workflows/test.yml)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/version.svg)](https://anaconda.org/conda-forge/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/platforms.svg)](https://anaconda.org/conda-forge/bmi-fortran)
[![Anaconda-Server Badge](https://anaconda.org/conda-forge/bmi-fortran/badges/downloads.svg)](https://anaconda.org/conda-forge/bmi-fortran)

# bmi-fortran

The Fortran specification, created with Fortran 2003,
for the CSDMS [Basic Model Interface](https://bmi.readthedocs.io).


## Build/Install

The Fortran BMI bindings can be built on Linux, macOS, and Windows.
Instructions are given below.

**Prerequisites:**
* A Fortran compiler
* CMake or [Fortran Package Manager](https://fpm.fortran-lang.org/)

Alternately,
[conda binaries](https://anaconda.org/conda-forge/bmi-fortran)
have been built for Linux, macOS, and Windows.
Install the Fortran BMI bindings (no build needed)
into an Anaconda distribution with

    conda install bmi-fortran -c conda-forge

### CMake - Linux and macOS

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
|   `-- bmif_2_0.mod
`-- lib
    |-- libbmif.so -> libbmif.so.2.0
    `-- libbmif.so.2.0
```

### CMake - Windows

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


### Fortran Package Manager (fpm)

If you don't already have fpm installed, you can do so via
Conda:

    conda install fpm -c conda-forge

Then, to build and install:

    fpm build --profile release
    fpm install --prefix <path-to-installation>

where `<path-to-installation>` is the base directory
in which to install the bindings. The default prefix
on Unix systems is `$HOME/.local` and `%APPDATA%\local`
on Windows. Note this differs from installs using CMake.

The installation will look like:

```bash
.
|-- include
|   `-- bmif_2_0.mod
`-- lib
    `-- libbmif.a
```

Note that fpm does not currently support the building
of shared/dyanmic libraries (`.so` on Unix, `.dll` on Windows).


## Use

To write a BMI for a model,
`use` the `bmif_2_0` module and implement all the BMI procedures
included in the interface defined therein.
BMI methods that aren't used
(e.g., `get_grid_x` for a uniform rectilinear grid)
can simply return the BMI_FAILURE status code.
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
for users who aren't comfortable with
the object-oriented features of Fortran 2003.
Further, both BMI implementations are backward-compatible with Fortran 77.
All that is needed is a compiler that's capable of handling
the more recent versions of Fortran;
for example `gfortran` in the GNU Compiler Collection.
