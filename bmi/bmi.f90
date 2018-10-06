module bmif

  implicit none

  integer, parameter :: BMI_MAX_COMPONENT_NAME = 2048
  integer, parameter :: BMI_MAX_VAR_NAME = 2048
  integer, parameter :: BMI_MAX_TYPE_NAME = 2048
  integer, parameter :: BMI_MAX_UNITS_NAME = 2048

  integer, parameter :: BMI_FAILURE = 1
  integer, parameter :: BMI_SUCCESS = 0

  type, abstract :: bmi
     contains
       procedure (bmif_get_component_name), deferred :: get_component_name
       procedure (bmif_get_input_var_names), deferred :: get_input_var_names
       procedure (bmif_get_output_var_names), deferred :: get_output_var_names
       procedure (bmif_initialize), deferred :: initialize
       procedure (bmif_finalize), deferred :: finalize
       procedure (bmif_get_start_time), deferred :: get_start_time
       procedure (bmif_get_end_time), deferred :: get_end_time
       procedure (bmif_get_current_time), deferred :: get_current_time
       procedure (bmif_get_time_step), deferred :: get_time_step
       procedure (bmif_get_time_units), deferred :: get_time_units
       procedure (bmif_update), deferred :: update
       procedure (bmif_update_frac), deferred :: update_frac
       procedure (bmif_update_until), deferred :: update_until
       procedure (bmif_get_var_grid), deferred :: get_var_grid
       procedure (bmif_get_grid_type), deferred :: get_grid_type
       procedure (bmif_get_grid_rank), deferred :: get_grid_rank
       procedure (bmif_get_grid_shape), deferred :: get_grid_shape
       procedure (bmif_get_grid_size), deferred :: get_grid_size
       procedure (bmif_get_grid_spacing), deferred :: get_grid_spacing
       procedure (bmif_get_grid_origin), deferred :: get_grid_origin
       procedure (bmif_get_grid_x), deferred :: get_grid_x
       procedure (bmif_get_grid_y), deferred :: get_grid_y
       procedure (bmif_get_grid_z), deferred :: get_grid_z
       procedure (bmif_get_grid_connectivity), deferred :: get_grid_connectivity
       procedure (bmif_get_grid_offset), deferred :: get_grid_offset
       procedure (bmif_get_var_type), deferred :: get_var_type
       procedure (bmif_get_var_units), deferred :: get_var_units
       procedure (bmif_get_var_itemsize), deferred :: get_var_itemsize
       procedure (bmif_get_var_nbytes), deferred :: get_var_nbytes
       procedure (bmif_get_value), deferred :: get_value
       procedure (bmif_get_value_ref), deferred :: get_value_ref
       procedure (bmif_get_value_at_indices), deferred :: get_value_at_indices
       procedure (bmif_set_value), deferred :: set_value
       procedure (bmif_set_value_at_indices), deferred :: set_value_at_indices
  end type bmi

  abstract interface

     ! Get the name of the model.
     function bmif_get_component_name(self, name) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), pointer, intent (out) :: name
       integer :: bmi_status
     end function bmif_get_component_name

     ! List a model's input variables.
     function bmif_get_input_var_names(self, names) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (*), pointer, intent (out) :: names(:)
       integer :: bmi_status
     end function bmif_get_input_var_names

     ! List a model's output variables.
     function bmif_get_output_var_names(self, names) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (*), pointer, intent (out) :: names(:)
       integer :: bmi_status
     end function bmif_get_output_var_names

     ! Perform startup tasks for the model.
     function bmif_initialize(self, config_file) result (bmi_status)
       import :: bmi
       class (bmi), intent (out) :: self
       character (len=*), intent (in) :: config_file
       integer :: bmi_status
     end function bmif_initialize

     ! Perform teardown tasks for the model.
     function bmif_finalize(self) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       integer :: bmi_status
     end function bmif_finalize

     ! Start time of the model.
     function bmif_get_start_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmif_get_start_time

     ! End time of the model.
     function bmif_get_end_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmif_get_end_time

     ! Current time of the model.
     function bmif_get_current_time(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time
       integer :: bmi_status
     end function bmif_get_current_time

     ! Time step of the model.
     function bmif_get_time_step(self, time_step) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       real, intent (out) :: time_step
       integer :: bmi_status
     end function bmif_get_time_step

     ! Time units of the model.
     function bmif_get_time_units(self, time_units) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (out) :: time_units
       integer :: bmi_status
     end function bmif_get_time_units

     ! Advance the model one time step.
     function bmif_update(self) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       integer :: bmi_status
     end function bmif_update

     ! Advance the model by a fraction of a time step.
     function bmif_update_frac(self, time_frac) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       real, intent (in) :: time_frac
       integer :: bmi_status
     end function bmif_update_frac

     ! Advance the model until the given time.
     function bmif_update_until(self, time) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       real, intent (in) :: time
       integer :: bmi_status
     end function bmif_update_until

     ! Get the grid identifier for the given variable.
     function bmif_get_var_grid(self, var_name, grid_id) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       integer, intent (out) :: grid_id
       integer :: bmi_status
     end function bmif_get_var_grid

     ! Get the grid type as a string.
     function bmif_get_grid_type(self, grid_id, grid_type) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       character (len=*), intent (out) :: grid_type
       integer :: bmi_status
     end function bmif_get_grid_type

     ! Get number of dimensions of the computational grid.
     function bmif_get_grid_rank(self, grid_id, rank) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, intent (out) :: rank
       integer :: bmi_status
     end function bmif_get_grid_rank

     ! Get the dimensions of the computational grid.
     function bmif_get_grid_shape(self, grid_id, shape) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, dimension(:), intent (out) :: shape
       integer :: bmi_status
     end function bmif_get_grid_shape

     ! Get the total number of elements in the computational grid.
     function bmif_get_grid_size(self, grid_id, size) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, intent (out) :: size
       integer :: bmi_status
     end function bmif_get_grid_size

     ! Get distance between nodes of the computational grid.
     function bmif_get_grid_spacing(self, grid_id, spacing) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: spacing
       integer :: bmi_status
     end function bmif_get_grid_spacing

     ! Get coordinates of the origin of the computational grid.
     function bmif_get_grid_origin(self, grid_id, origin) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: origin
       integer :: bmi_status
     end function bmif_get_grid_origin

     ! Get the x-coordinates of the nodes of a computational grid.
     function bmif_get_grid_x(self, grid_id, x) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: x
       integer :: bmi_status
     end function bmif_get_grid_x

     ! Get the y-coordinates of the nodes of a computational grid.
     function bmif_get_grid_y(self, grid_id, y) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: y
       integer :: bmi_status
     end function bmif_get_grid_y

     ! Get the z-coordinates of the nodes of a computational grid.
     function bmif_get_grid_z(self, grid_id, z) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       real, dimension(:), intent (out) :: z
       integer :: bmi_status
     end function bmif_get_grid_z

     ! Get the connectivity array of the nodes of an unstructured grid.
     function bmif_get_grid_connectivity(self, grid_id, conn) &
          result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, dimension(:), intent (out) :: conn
       integer :: bmi_status
     end function bmif_get_grid_connectivity

     ! Get the offsets of the nodes of an unstructured grid.
     function bmif_get_grid_offset(self, grid_id, offset) &
          result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       integer, intent (in) :: grid_id
       integer, dimension(:), intent (out) :: offset
       integer :: bmi_status
     end function bmif_get_grid_offset

     ! Get the data type of the given variable as a string.
     function bmif_get_var_type(self, var_name, type) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       character (len=*), intent (out) :: type
       integer :: bmi_status
     end function bmif_get_var_type

     ! Get the units of the given variable.
     function bmif_get_var_units(self, var_name, units) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       character (len=*), intent (out) :: units
       integer :: bmi_status
     end function bmif_get_var_units

     ! Get memory use per array element, in bytes.
     function bmif_get_var_itemsize(self, var_name, size) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       integer, intent (out) :: size
       integer :: bmi_status
     end function bmif_get_var_itemsize

     ! Get size of the given variable, in bytes.
     function bmif_get_var_nbytes(self, var_name, size) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       integer, intent (out) :: size
       integer :: bmi_status
     end function bmif_get_var_nbytes

     ! Get a copy of values (flattened!) of the given variable.
     function bmif_get_value(self, var_name, dest) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       real, pointer, intent (inout) :: dest(:)
       integer :: bmi_status
     end function bmif_get_value

     ! Get a reference to the values (flattened!) of the given variable.
     function bmif_get_value_ref(self, var_name, dest) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       real, pointer, intent (inout) :: dest(:)
       integer :: bmi_status
     end function bmif_get_value_ref

     ! Get values at particular (one-dimensional) indices.
     function bmif_get_value_at_indices(self, var_name, dest, indices) result (bmi_status)
       import :: bmi
       class (bmi), intent (in) :: self
       character (len=*), intent (in) :: var_name
       real, pointer, intent (inout) :: dest(:)
       integer, intent (in) :: indices(:)
       integer :: bmi_status
     end function bmif_get_value_at_indices

     ! Set a new value for a model variable.
     function bmif_set_value(self, var_name, src) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       character (len=*), intent (in) :: var_name
       real, intent (in) :: src(:)
       integer :: bmi_status
     end function bmif_set_value

     ! Set values at particular (one-dimensional) indices.
     function bmif_set_value_at_indices(self, var_name, indices, src) result (bmi_status)
       import :: bmi
       class (bmi), intent (inout) :: self
       character (len=*), intent (in) :: var_name
       integer, intent (in) :: indices(:)
       real, intent (in) :: src(:)
       integer :: bmi_status
     end function bmif_set_value_at_indices

  end interface

end module bmif
