module bmiheatf

  use heat
  use bmif

  type, extends (bmi) :: bmi_heat
   contains
     procedure :: get_component_name => heat_component_name
  end type bmi_heat

  private :: heat_component_name

  character (len=BMI_MAXCOMPNAMESTR), target :: &
       component_name = "The 2D Heat Equation"

contains

  function heat_component_name(self, name) result (bmi_status)
    class (bmi_heat), intent (in) :: self
    character (len=BMI_MAXCOMPNAMESTR), pointer, intent (out) :: name
    integer :: bmi_status

    name => component_name
    bmi_status = BMI_SUCCESS
  end function heat_component_name

end module bmiheatf
