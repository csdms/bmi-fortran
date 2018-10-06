module bmiheatf

  use heatf
  use bmif
  use, intrinsic :: iso_c_binding, only: c_ptr, c_loc, c_f_pointer
  implicit none

  type, extends (bmi) :: bmi_heat
     private
     type (heat_model) :: model
   contains
     procedure :: get_component_name => heat_component_name
     procedure :: get_input_var_names => heat_input_var_names
     procedure :: get_output_var_names => heat_output_var_names
     procedure :: initialize => heat_initialize
     procedure :: finalize => heat_finalize
     procedure :: get_start_time => heat_start_time
     procedure :: get_end_time => heat_end_time
     procedure :: get_current_time => heat_current_time
     procedure :: get_time_step => heat_time_step
     procedure :: get_time_units => heat_time_units
     procedure :: update => heat_update
     procedure :: update_frac => heat_update_frac
     procedure :: update_until => heat_update_until
     procedure :: get_var_grid => heat_var_grid
     procedure :: get_grid_type => heat_grid_type
     procedure :: get_grid_rank => heat_grid_rank
     procedure :: get_grid_shape => heat_grid_shape
     procedure :: get_grid_size => heat_grid_size
     procedure :: get_grid_spacing => heat_grid_spacing
     procedure :: get_grid_origin => heat_grid_origin
     procedure :: get_grid_x => heat_grid_x
     procedure :: get_grid_y => heat_grid_y
     procedure :: get_grid_z => heat_grid_z
     procedure :: get_grid_connectivity => heat_grid_connectivity
     procedure :: get_grid_offset => heat_grid_offset
     procedure :: get_var_type => heat_var_type
     procedure :: get_var_units => heat_var_units
     procedure :: get_var_itemsize => heat_var_itemsize
     procedure :: get_var_nbytes => heat_var_nbytes
     procedure :: get_value => heat_get
     procedure :: get_value_ref => heat_get_ref
     procedure :: get_value_at_indices => heat_get_at_indices
     procedure :: set_value => heat_set
     procedure :: set_value_at_indices => heat_set_at_indices
  end type bmi_heat

  private :: heat_component_name, heat_input_var_names, heat_output_var_names
  private :: heat_initialize, heat_finalize
  private :: heat_start_time, heat_end_time, heat_current_time
  private :: heat_time_step, heat_time_units
  private :: heat_update, heat_update_frac, heat_update_until
  private :: heat_var_grid
  private :: heat_grid_type, heat_grid_rank, heat_grid_shape
  private :: heat_grid_size, heat_grid_spacing, heat_grid_origin
  private :: heat_grid_x, heat_grid_y, heat_grid_z
  private :: heat_grid_connectivity, heat_grid_offset
  private :: heat_var_type, heat_var_units, heat_var_itemsize, heat_var_nbytes
  private :: heat_get, heat_get_ref, heat_get_at_indices
  private :: heat_set, heat_set_at_indices

  character (len=BMI_MAX_COMPONENT_NAME), target :: &
       component_name = "The 2D Heat Equation"

  ! Exchange items
  integer, parameter :: input_item_count = 2
  integer, parameter :: output_item_count = 1
  character (len=BMI_MAX_VAR_NAME), target, &
       dimension (input_item_count) :: input_items
  character (len=BMI_MAX_VAR_NAME), target, &
       dimension (output_item_count) :: &
       output_items = (/'plate_surface__temperature'/)

contains

  ! Get the name of the model.
  function heat_component_name(self, name) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), pointer, intent (out) :: name
    integer :: bmi_status

    name => component_name
    bmi_status = BMI_SUCCESS
  end function heat_component_name

  ! List input variables.
  function heat_input_var_names(self, names) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (*), pointer, intent (out) :: names(:)
    integer :: bmi_status

    input_items(1) = 'plate_surface__temperature'
    input_items(2) = 'plate_surface__thermal_diffusivity'

    names => input_items
    bmi_status = BMI_SUCCESS
  end function heat_input_var_names

  ! List output variables.
  function heat_output_var_names(self, names) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (*), pointer, intent (out) :: names(:)
    integer :: bmi_status

    names => output_items
    bmi_status = BMI_SUCCESS
  end function heat_output_var_names

  ! BMI initializer.
  function heat_initialize(self, config_file) result (bmi_status)
    class (bmi_heat), intent (out) :: self
    character (len=*), intent (in) :: config_file
    integer :: bmi_status

    if (len (config_file) > 0) then
       call initialize_from_file(self%model, config_file)
    else
       call initialize_from_defaults(self%model)
    end if
    bmi_status = BMI_SUCCESS
  end function heat_initialize

  ! BMI finalizer.
  function heat_finalize(self) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    integer :: bmi_status

    call cleanup(self%model)
    bmi_status = BMI_SUCCESS
  end function heat_finalize

  ! Model start time.
  function heat_start_time(self, time) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    real, intent (out) :: time
    integer :: bmi_status

    time = 0.0
    bmi_status = BMI_SUCCESS
  end function heat_start_time

  ! Model end time.
  function heat_end_time(self, time) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    real, intent (out) :: time
    integer :: bmi_status

    time = self%model%t_end
    bmi_status = BMI_SUCCESS
  end function heat_end_time

  ! Model current time.
  function heat_current_time(self, time) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    real, intent (out) :: time
    integer :: bmi_status

    time = self%model%t
    bmi_status = BMI_SUCCESS
  end function heat_current_time

  ! Model time step.
  function heat_time_step(self, time_step) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    real, intent (out) :: time_step
    integer :: bmi_status

    time_step = self%model%dt
    bmi_status = BMI_SUCCESS
  end function heat_time_step

  ! Model time units.
  function heat_time_units(self, time_units) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (out) :: time_units
    integer :: bmi_status

    time_units = "-"
    bmi_status = BMI_SUCCESS
  end function heat_time_units

  ! Advance model by one time step.
  function heat_update(self) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    integer :: bmi_status

    call advance_in_time(self%model)
    bmi_status = BMI_SUCCESS
  end function heat_update

  ! Advance the model by a fraction of a time step.
  function heat_update_frac(self, time_frac) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    real, intent (in) :: time_frac
    integer :: bmi_status
    real :: time_step

    if (time_frac > 0.0) then
       time_step = self%model%dt
       self%model%dt = time_step*time_frac
       call advance_in_time(self%model)
       self%model%dt = time_step
    end if
    bmi_status = BMI_SUCCESS
  end function heat_update_frac

  ! Advance the model until the given time.
  function heat_update_until(self, time) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    real, intent (in) :: time
    integer :: bmi_status
    real :: n_steps_real
    integer :: n_steps, i, s

    if (time > self%model%t) then
       n_steps_real = (time - self%model%t) / self%model%dt
       n_steps = floor(n_steps_real)
       do i = 1, n_steps
          s = self%update()
       end do
       s = self%update_frac(n_steps_real - real(n_steps))
    end if
    bmi_status = BMI_SUCCESS
  end function heat_update_until

  ! Get the grid id for a particular variable.
  function heat_var_grid(self, var_name, grid_id) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    integer, intent (out) :: grid_id
    integer :: bmi_status

    select case (var_name)
    case ('plate_surface__temperature')
       grid_id = 0
       bmi_status = BMI_SUCCESS
    case ('plate_surface__thermal_diffusivity')
       grid_id = 1
       bmi_status = BMI_SUCCESS
    case default
       grid_id = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_grid

  ! The type of a variable's grid.
  function heat_grid_type(self, grid_id, grid_type) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    character (len=*), intent (out) :: grid_type
    integer :: bmi_status

    select case (grid_id)
    case (0)
       grid_type = "uniform_rectilinear"
       bmi_status = BMI_SUCCESS
    case (1)
       grid_type = "unstructured"
       bmi_status = BMI_SUCCESS
    case default
       grid_type = "-"
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_type

  ! The number of dimensions of a grid.
  function heat_grid_rank(self, grid_id, rank) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    integer, intent (out) :: rank
    integer :: bmi_status

    select case (grid_id)
    case (0)
       rank = 2
       bmi_status = BMI_SUCCESS
    case (1)
       rank = 0
       bmi_status = BMI_SUCCESS
    case default
       rank = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_rank

  ! The dimensions of a grid.
  function heat_grid_shape(self, grid_id, shape) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    integer, dimension(:), intent (out) :: shape
    integer :: bmi_status

    select case (grid_id)
    case (0)
       shape = [self%model%n_y, self%model%n_x]
       bmi_status = BMI_SUCCESS
    case default
       shape = [-1]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_shape

  ! The total number of elements in a grid.
  function heat_grid_size(self, grid_id, size) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    integer, intent (out) :: size
    integer :: bmi_status

    select case (grid_id)
    case (0)
       size = self%model%n_y * self%model%n_x
       bmi_status = BMI_SUCCESS
    case (1)
       size = 1
       bmi_status = BMI_SUCCESS
    case default
       size = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_size

  ! The distance between nodes of a grid.
  function heat_grid_spacing(self, grid_id, spacing) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    real, dimension(:), intent (out) :: spacing
    integer :: bmi_status

    select case (grid_id)
    case (0)
       spacing = [self%model%dy, self%model%dx]
       bmi_status = BMI_SUCCESS
    case default
       spacing = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_spacing

  ! Coordinates of grid origin.
  function heat_grid_origin(self, grid_id, origin) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    real, dimension(:), intent (out) :: origin
    integer :: bmi_status

    select case (grid_id)
    case (0)
       origin = [0.0, 0.0]
       bmi_status = BMI_SUCCESS
    case default
       origin = [-1.0]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_origin

  ! X-coordinates of grid nodes.
  function heat_grid_x(self, grid_id, x) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    real, dimension(:), intent (out) :: x
    integer :: bmi_status

    select case (grid_id)
    case (1)
       x = [0.0]
       bmi_status = BMI_SUCCESS
    case default
       x = [-1.0]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_x

  ! Y-coordinates of grid nodes.
  function heat_grid_y(self, grid_id, y) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    real, dimension(:), intent (out) :: y
    integer :: bmi_status

    select case (grid_id)
    case (1)
       y = [0.0]
       bmi_status = BMI_SUCCESS
    case default
       y = [-1.0]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_y

  ! Z-coordinates of grid nodes.
  function heat_grid_z(self, grid_id, z) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    real, dimension(:), intent (out) :: z
    integer :: bmi_status

    select case (grid_id)
    case (1)
       z = [0.0]
       bmi_status = BMI_SUCCESS
    case default
       z = [-1.0]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_z

  ! Connectivity array of unstructured grid nodes.
  function heat_grid_connectivity(self, grid_id, connectivity) &
       result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    integer, dimension(:), intent (out) :: connectivity
    integer :: bmi_status

    select case (grid_id)
    case (1)
       connectivity = [0]
       bmi_status = BMI_SUCCESS
    case default
       connectivity = [-1]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_connectivity

  ! Offsets of unstructured grid nodes.
  function heat_grid_offset(self, grid_id, offset) &
       result (bmi_status)
    class (bmi_heat), intent (in) :: self
    integer, intent (in) :: grid_id
    integer, dimension(:), intent (out) :: offset
    integer :: bmi_status

    select case (grid_id)
    case (1)
       offset = [0]
       bmi_status = BMI_SUCCESS
    case default
       offset = [-1]
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_offset

  ! The data type of the variable, as a string.
  function heat_var_type(self, var_name, type) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    character (len=*), intent (out) :: type
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       type = "real"
       bmi_status = BMI_SUCCESS
    case ("plate_surface__thermal_diffusivity")
       type = "real"
       bmi_status = BMI_SUCCESS
    case default
       type = "-"
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_type

  ! The units of the given variable.
  function heat_var_units(self, var_name, units) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    character (len=*), intent (out) :: units
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       units = "K"
       bmi_status = BMI_SUCCESS
    case ("plate_surface__thermal_diffusivity")
       units = "m2 s-1"
       bmi_status = BMI_SUCCESS
    case default
       units = "-"
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_units

  ! Memory use per array element.
  function heat_var_itemsize(self, var_name, size) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    integer, intent (out) :: size
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       size = sizeof(self%model%temperature(1,1))  ! 'sizeof' in gcc & ifort
       bmi_status = BMI_SUCCESS
    case ("plate_surface__thermal_diffusivity")
       size = sizeof(self%model%alpha)             ! 'sizeof' in gcc & ifort
       bmi_status = BMI_SUCCESS
    case default
       size = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_itemsize

  ! The size of the given variable.
  function heat_var_nbytes(self, var_name, size) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    integer, intent (out) :: size
    integer :: bmi_status
    integer :: s1, s2, s3, grid_id, grid_size, item_size

    s1 = self%get_var_grid(var_name, grid_id)
    s2 = self%get_grid_size(grid_id, grid_size)
    s3 = self%get_var_itemsize(var_name, item_size)

    if ((s1 == BMI_SUCCESS).and.(s2 == BMI_SUCCESS).and.(s3 == BMI_SUCCESS)) then
       size = item_size * grid_size
       bmi_status = BMI_SUCCESS
    else
       size = -1
       bmi_status = BMI_FAILURE
    end if
  end function heat_var_nbytes

  ! Get a copy of a variable's values, flattened.
  function heat_get(self, var_name, dest) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    real, pointer, intent (inout) :: dest(:)
    integer :: bmi_status
    integer :: status, grid_id, grid_size

    status = self%get_var_grid(var_name, grid_id)
    status = self%get_grid_size(grid_id, grid_size)

    select case (var_name)
    case ("plate_surface__temperature")
       allocate(dest(grid_size))
       dest = reshape(self%model%temperature, [grid_size])
       bmi_status = BMI_SUCCESS
    case ("plate_surface__thermal_diffusivity")
       allocate(dest(grid_size))
       dest = [self%model%alpha]
       bmi_status = BMI_SUCCESS
    case default
       grid_size = 1
       allocate(dest(grid_size))
       dest = -1.0
       bmi_status = BMI_FAILURE
    end select
  end function heat_get

  ! Get a reference to a variable's values, flattened.
  function heat_get_ref(self, var_name, dest) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    real, pointer, intent (inout) :: dest(:)
    integer :: bmi_status
    type (c_ptr) :: src
    integer :: n_elements

    select case (var_name)
    case ("plate_surface__temperature")
       src = c_loc (self%model%temperature(1,1))
       n_elements = self%model%n_y * self%model%n_x
       call c_f_pointer(src, dest, [n_elements])
       bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
  end function heat_get_ref

  ! Get values of a variable at the given locations.
  function heat_get_at_indices(self, var_name, dest, indices) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=*), intent (in) :: var_name
    real, pointer, intent (inout) :: dest(:)
    integer, intent (in) :: indices(:)
    integer :: bmi_status
    type (c_ptr) src
    real, pointer :: src_flattened(:)
    integer :: i, n_elements

    select case (var_name)
    case ("plate_surface__temperature")
       src = c_loc (self%model%temperature(1,1))
       call c_f_pointer(src, src_flattened, [self%model%n_y * self%model%n_x])
       n_elements = size (indices)
       allocate(dest(n_elements))
       do i = 1, n_elements
          dest(i) = src_flattened(indices(i))
       end do
       bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
  end function heat_get_at_indices

  ! Set new values.
  function heat_set(self, var_name, src) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    character (len=*), intent (in) :: var_name
    real, intent (in) :: src(:)
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       self%model%temperature = reshape(src, [self%model%n_y, self%model%n_x])
       bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
  end function heat_set

  ! Set new values at particular locations.
  function heat_set_at_indices(self, var_name, indices, src) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    character (len=*), intent (in) :: var_name
    integer, intent (in) :: indices(:)
    real, intent (in) :: src(:)
    integer :: bmi_status
    type (c_ptr) dest
    real, pointer :: dest_flattened(:)
    integer :: i

    select case (var_name)
    case ("plate_surface__temperature")
       dest = c_loc (self%model%temperature(1,1))
       call c_f_pointer(dest, dest_flattened, [self%model%n_y * self%model%n_x])
       do i = 1, size (indices)
          dest_flattened(indices(i)) = src(i)
       end do
       bmi_status = BMI_SUCCESS
    case default
       bmi_status = BMI_FAILURE
    end select
  end function heat_set_at_indices

end module bmiheatf
