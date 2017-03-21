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
  end type bmi_heat

  private :: heat_component_name, heat_input_var_names, heat_output_var_names
  private :: heat_initialize, heat_finalize

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

end module bmiheatf
