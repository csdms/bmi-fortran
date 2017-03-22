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
       procedure (bmi_get_start_time), deferred :: get_start_time
       procedure (bmi_get_end_time), deferred :: get_end_time
       procedure (bmi_get_current_time), deferred :: get_current_time
       procedure (bmi_get_time_step), deferred :: get_time_step
       procedure (bmi_get_time_units), deferred :: get_time_units
       procedure (bmi_update), deferred :: update
       procedure (bmi_update_frac), deferred :: update_frac
       procedure (bmi_update_until), deferred :: update_until
       procedure (bmi_get_var_grid), deferred :: get_var_grid
       procedure (bmi_get_grid_type), deferred :: get_grid_type
       procedure (bmi_get_grid_rank), deferred :: get_grid_rank
       procedure (bmi_get_grid_shape), deferred :: get_grid_shape
       procedure (bmi_get_grid_size), deferred :: get_grid_size
       procedure (bmi_get_grid_spacing), deferred :: get_grid_spacing
       procedure (bmi_get_grid_origin), deferred :: get_grid_origin
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

     ! Start time of the model.
     function bmi_get_start_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmi_get_start_time

     ! End time of the model.
     function bmi_get_end_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmi_get_end_time

     ! Current time of the model.
     function bmi_get_current_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmi_get_current_time

     ! Time step of the model.
     function bmi_get_time_step(self, time_step) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time_step
       integer :: bmi_status
     end function bmi_get_time_step

     ! Time units of the model.
     function bmi_get_time_units(self, time_units) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (out) :: time_units
       integer :: bmi_status
     end function bmi_get_time_units

     ! Advance the model one time step.
     function bmi_update(self) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       integer :: bmi_status
     end function bmi_update

     ! Advance the model by a fraction of a time step.
     function bmi_update_frac(self, time_frac) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       real, intent (in) :: time_frac
       integer :: bmi_status
     end function bmi_update_frac

     ! Advance the model until the given time.
     function bmi_update_until(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       real, intent (in) :: time
       integer :: bmi_status
     end function bmi_update_until

     ! Get the grid identifier for the given variable.
     function bmi_get_var_grid(self, var_name, grid_id) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       integer, intent (out) :: grid_id
       integer :: bmi_status
     end function bmi_get_var_grid

     ! Get the grid type as a string.
     function bmi_get_grid_type(self, grid_id, grid_type) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       character (len=*), intent (out) :: grid_type
       integer :: bmi_status
     end function bmi_get_grid_type

     ! Get number of dimensions of the computational grid.
     function bmi_get_grid_rank(self, grid_id, rank) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, intent (out) :: rank
       integer :: bmi_status
     end function bmi_get_grid_rank

     ! Get the dimensions of the computational grid.
     function bmi_get_grid_shape(self, grid_id, shape) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, dimension(:), intent (out) :: shape
       integer :: bmi_status
     end function bmi_get_grid_shape

     ! Get the total number of elements in the computational grid.
     function bmi_get_grid_size(self, grid_id, size) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, intent (out) :: size
       integer :: bmi_status
     end function bmi_get_grid_size

     ! Get distance between nodes of the computational grid.
     function bmi_get_grid_spacing(self, grid_id, spacing) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: spacing
       integer :: bmi_status
     end function bmi_get_grid_spacing

     function bmi_get_grid_origin(self, grid_id, origin) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: origin
       integer :: bmi_status
     end function bmi_get_grid_origin

  end interface

end module bmif
