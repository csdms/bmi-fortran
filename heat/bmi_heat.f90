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
     procedure :: get_var_grid => heat_get_var_grid
  end type bmi_heat

  private :: heat_component_name, heat_input_var_names, heat_output_var_names
  private :: heat_initialize, heat_finalize
  private :: heat_start_time, heat_end_time, heat_current_time
  private :: heat_time_step, heat_time_units
  private :: heat_update, heat_update_frac, heat_update_until
  private :: heat_get_var_grid

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

  function heat_get_var_grid(self, var_name, grid_id) result (bmi_status)
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
  end function heat_get_var_grid

end module bmiheatf
