module bmiheatf

  use heatf
  use bmif

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
     procedure :: get_var_type => heat_var_type
     procedure :: get_var_units => heat_var_units
     procedure :: get_var_itemsize => heat_var_itemsize
     procedure :: get_var_nbytes => heat_var_nbytes
  end type bmi_heat

  private :: heat_component_name, heat_input_var_names, heat_output_var_names
  private :: heat_initialize, heat_finalize
  private :: heat_start_time, heat_end_time, heat_current_time
  private :: heat_time_step, heat_time_units
  private :: heat_update, heat_update_frac, heat_update_until
  private :: heat_var_grid
  private :: heat_grid_type, heat_grid_rank, heat_grid_shape
  private :: heat_grid_size, heat_grid_spacing, heat_grid_origin
  private :: heat_var_type, heat_var_units, heat_var_itemsize, heat_var_nbytes

  character (len=BMI_MAXCOMPNAMESTR), target :: &
       component_name = "The 2D Heat Equation"

  ! Exchange items
  integer, parameter :: input_item_count = 1
  integer, parameter :: output_item_count = 1
  character (len=BMI_MAXVARNAMESTR), target, &
       dimension (input_item_count) :: &
       input_items = (/'plate_surface__temperature'/)
  character (len=BMI_MAXVARNAMESTR), target, &
       dimension (output_item_count) :: &
       output_items = (/'plate_surface__temperature'/)

contains

  ! Get the name of the model.
  function heat_component_name(self, name) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=BMI_MAXCOMPNAMESTR), pointer, intent (out) :: name
    integer :: bmi_status

    name => component_name
    bmi_status = BMI_SUCCESS
  end function heat_component_name

  ! List input variables.
  function heat_input_var_names(self, names) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (*), pointer, intent (out) :: names(:)
    integer :: bmi_status

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
    status = BMI_SUCCESS
  end function heat_initialize

  ! BMI finalizer.
  function heat_finalize(self) result (bmi_status)
    class (bmi_heat), intent (inout) :: self
    integer :: bmi_status

    call cleanup(self%model)
    status = BMI_SUCCESS
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
    character (len=BMI_MAXVARNAMESTR), intent (in) :: var_name
    integer, intent (out) :: grid_id
    integer :: bmi_status

    select case (var_name)
    case ('plate_surface__temperature')
       grid_id = 0
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
    character (len=BMI_MAXVARNAMESTR), intent (out) :: grid_type
    integer :: bmi_status

    select case (grid_id)
    case (0)
       grid_type = "uniform_rectilinear"
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
       shape = [-1, -1]
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
       bmi_status = BMI_FAILURE
    end select
  end function heat_grid_origin

  ! The data type of the variable, as a string.
  function heat_var_type(self, var_name, type) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=BMI_MAXVARNAMESTR), intent (in) :: var_name
    character (len=BMI_MAXUNITSSTR), intent (out) :: type
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
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
    character (len=BMI_MAXVARNAMESTR), intent (in) :: var_name
    character (len=BMI_MAXUNITSSTR), intent (out) :: units
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       units = "K"
       bmi_status = BMI_SUCCESS
    case default
       units = "-"
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_units

  ! Memory use per array element.
  function heat_var_itemsize(self, var_name, size) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=BMI_MAXVARNAMESTR), intent (in) :: var_name
    integer, intent (out) :: size
    integer :: bmi_status

    select case (var_name)
    case ("plate_surface__temperature")
       size = BMI_DOUBLE
       bmi_status = BMI_SUCCESS
    case default
       size = -1
       bmi_status = BMI_FAILURE
    end select
  end function heat_var_itemsize

  ! The size of the given variable.
  function heat_var_nbytes(self, var_name, size) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=BMI_MAXVARNAMESTR), intent (in) :: var_name
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

end module bmiheatf