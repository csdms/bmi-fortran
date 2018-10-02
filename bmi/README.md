# bmi

The Fortran Basic Model Interface (BMI)
is defined in the file **bmi.f90**.

To write a BMI for a model,
drop this file alongside the model,
`use` the `bmif` module,
and implement all the BMI procedures
included in the interface defined in `bmif`.

    model/
	  bmi.f90        # the file described here
	  bmi_model.f90  # the BMI you write for the model
	  model.f90      # the model

An example of how to implement this BMI is given
in the [heat](../heat) directory.
