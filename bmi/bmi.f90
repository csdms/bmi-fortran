module bmif

  implicit none

  integer, parameter :: BMI_VAR_TYPE_UNKNOWN = 0
  integer, parameter :: BMI_VAR_TYPE_CHAR = 1
  integer, parameter :: BMI_VAR_TYPE_UNSIGNED_CHAR = 2
  integer, parameter :: BMI_VAR_TYPE_INT = 3
  integer, parameter :: BMI_VAR_TYPE_LONG = 4
  integer, parameter :: BMI_VAR_TYPE_UNSIGNED_INT = 5
  integer, parameter :: BMI_VAR_TYPE_UNSIGNED_LONG = 6
  integer, parameter :: BMI_VAR_TYPE_FLOAT = 7
  integer, parameter :: BMI_VAR_TYPE_DOUBLE = 8
  integer, parameter :: BMI_VAR_TYPE_NUMBER = 9

  integer, parameter :: BMI_GRID_TYPE_UNKNOWN = 0
  integer, parameter :: BMI_GRID_TYPE_UNIFORM = 1
  integer, parameter :: BMI_GRID_TYPE_RECTILINEAR = 2
  integer, parameter :: BMI_GRID_TYPE_STRUCTURED = 3
  integer, parameter :: BMI_GRID_TYPE_UNSTRUCTURED = 4
  integer, parameter :: BMI_GRID_TYPE_NUMBER = 5

  integer, parameter :: BMI_MAXVARNAMESTR = 63
  integer, parameter :: BMI_MAXCOMPNAMESTR = 63
  integer, parameter :: BMI_MAXUNITSSTR = 63

  integer, parameter :: BMI_CHAR = 1
  integer, parameter :: BMI_UNSIGNED_CHAR = 1
  integer, parameter :: BMI_INT = 2
  integer, parameter :: BMI_LONG = 4
  integer, parameter :: BMI_UNSIGNED_INT = 2
  integer, parameter :: BMI_UNSIGNED_LONG = 4
  integer, parameter :: BMI_FLOAT = 4
  integer, parameter :: BMI_DOUBLE = 8

  integer, parameter :: BMI_FAILURE = 0
  integer, parameter :: BMI_SUCCESS = 1

  type, abstract :: bmi
     contains
       procedure (bmi_get_component_name), deferred :: get_component_name
       procedure (bmi_get_input_var_names), deferred :: get_input_var_names
       procedure (bmi_get_output_var_names), deferred :: get_output_var_names
       procedure (bmi_initialize), deferred :: initialize
       procedure (bmi_finalize), deferred :: finalize
  end type bmi

  abstract interface

     ! Get the name of the model.
     function bmi_get_component_name(self, name) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), pointer, intent (out) :: name
       integer :: bmi_status
     end function bmi_get_component_name

     ! List a model's input variables.
     function bmi_get_input_var_names(self, names) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (*), pointer, intent (out) :: names(:)
       integer :: bmi_status
     end function bmi_get_input_var_names

     ! List a model's output variables.
     function bmi_get_output_var_names(self, names) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (*), pointer, intent (out) :: names(:)
       integer :: bmi_status
     end function bmi_get_output_var_names

     ! Perform startup tasks for the model.
     function bmi_initialize(self, config_file) result (bmi_status)
       import :: bmi
       class (bmi), intent (out) :: self
       character (len=*), intent (in) :: config_file
       integer :: bmi_status
     end function bmi_initialize

     ! Perform teardown tasks for the model.
     function bmi_finalize(self) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       integer :: bmi_status
     end function bmi_finalize

  end interface

end module bmif
