# heat

This is a sample implementation of the Fortran BMI.
A model, `heatf`,
which  solves the diffusion equation on a uniform rectangular plate
with Dirichlet boundary conditions,
is wrapped with the Fortran BMI defined
in the [bmi](../bmi) directory.
Tests and examples of using the BMI are provided.

Files and directories:

* **heat.f90**: The diffusion model, `heatf`.
* **main.f90**: An example main program that runs `heatf`.
* **bmi_heat.f90**: A BMI that wraps `heatf`.
* **bmi_main.f90**: An example main program that runs `heatf` through its BMI.
* **examples/**: Examples of running the `heatf` BMI.
* **tests/**: Unit tests for the `heatf` BMI.
