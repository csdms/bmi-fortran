[![Build Status](https://travis-ci.org/csdms/bmi-fortran.svg?branch=master)](https://travis-ci.org/csdms/bmi-fortran)

# bmi-fortran

Fortran bindings, created with Fortran 2003, for the
[Basic Model Interface](http://csdms.colorado.edu/wiki/BMI_Description),
following the [BMI specification](https://bmi-spec.readthedocs.io).
The bindings themseleves are defined in the [bmi](./bmi) directory.
A sample implementation,
with tests and examples,
is provided in the [heat](./heat) directory.

For a Fortran BMI that uses Fortran 90/95,
see https://github.com/csdms/bmi-f90.

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
for users who aren't comfortable
the object-oriented features of Fortran 2003.
Further, both BMI implementations are backward-compatible with Fortran 77.
All that is needed is a compiler that's capable of handling
the more recent versions of Fortran;
for example `gfortran` in the GNU Compiler Collection.
