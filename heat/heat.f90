! An example of the heat equation.
module heat

  implicit none

  ! Define the attributes of the model.
  type :: heat_model
     real :: dt
     real :: t
     real :: t_end

     real :: alpha

     integer :: n_x
     integer :: n_y

     real :: dx
     real :: dy

     real, pointer :: temperature(:,:)
     real, pointer :: temperature_tmp(:,:)
  end type heat_model

  private :: initialize, set_boundary_conditions

contains

  ! Initializes the model with values read from a file.
  subroutine initialize_from_file(model, config_file)
    character (len=*), intent (in) :: config_file
    type (heat_model), intent (out) :: model

    open(15, file=config_file)
    read(15, *) model%alpha, model%t_end, model%n_x, model%n_y
    close(15)
    call initialize(model)
  end subroutine initialize_from_file

  ! Initializes the model with default hardcoded values.
  subroutine initialize_from_defaults(model)
    type (heat_model), intent (out) :: model

    model%alpha = 0.75
    model%t_end = 20.
    model%n_x = 10
    model%n_y = 20
    call initialize(model)
  end subroutine initialize_from_defaults

  ! Allocates memory and sets values for either initialization technique.
  subroutine initialize(model)
    type (heat_model), intent (inout) :: model

    model%t = 0.
    model%dt = 1.
    model%dx = 1.
    model%dy = 1.

    allocate(model%temperature(model%n_y, model%n_x))
    allocate(model%temperature_tmp(model%n_y, model%n_x))

    model%temperature = 0.
    model%temperature_tmp = 0.

    call set_boundary_conditions(model%temperature)
    call set_boundary_conditions(model%temperature_tmp)
  end subroutine initialize

  ! Sets boundary conditions on values array.
  subroutine set_boundary_conditions(z)
    implicit none
    real, dimension (:,:), intent (out) :: z
    integer :: i, top_x

    top_x = size(z, 2)-1

    do i = 0, top_x
       z(1,i+1) = 0.25*top_x**2 - (i - 0.5*top_x)**2
    end do
  end subroutine set_boundary_conditions

  ! Frees memory when program completes.
  subroutine cleanup(model)
    type (heat_model), intent (inout) :: model

    deallocate (model%temperature)
    deallocate (model%temperature_tmp)
  end subroutine cleanup

  ! Steps the heat model forward in time.
  subroutine advance_in_time(model)
    type (heat_model), intent (inout) :: model

    call solve_2d(model)
    model%temperature = model%temperature_tmp
    model%t = model%t + model%dt
  end subroutine advance_in_time

  ! The solver for the two-dimensional heat equation.
  subroutine solve_2d(model)
    type (heat_model), intent (inout) :: model

    real :: dx2
    real :: dy2
    real :: coef
    integer :: i, j

    dx2 = model%dx**2
    dy2 = model%dy**2
    coef = model%alpha * model%dt / (2. * (dx2 + dy2))

    do i = 2, model%n_y-1
       do j = 2, model%n_x-1
          model%temperature_tmp(i,j) = &
               model%temperature(i,j) + coef * ( &
               dx2*(model%temperature(i-1,j) + model%temperature(i+1,j)) + &
               dy2*(model%temperature(i,j-1) + model%temperature(i,j+1)) - &
               2.*(dx2 + dy2)*model%temperature(i,j) )
       end do
    end do
  end subroutine solve_2d

  ! A helper routine for displaying model parameters.
  subroutine print_info(model)
    type (heat_model), intent (in) :: model

    write(*,"(a10, i8)") "n_x:", model%n_x
    write(*,"(a10, i8)") "n_y:", model%n_y
    write(*,"(a10, f8.2)") "dx:", model%dx
    write(*,"(a10, f8.2)") "dy:", model%dy
    write(*,"(a10, f8.2)") "alpha:", model%alpha
    write(*,"(a10, f8.2)") "dt:", model%dt
    write(*,"(a10, f8.2)") "t:", model%t
    write(*,"(a10, f8.2)") "t_end:", model%t_end
  end subroutine print_info

  ! A helper routine that prints the current state of the model.
  subroutine print_values(model)
    type (heat_model), intent (in) :: model
    integer :: i, j
    character(len=30) :: rowfmt

    write(rowfmt,'(a,i4,a)') '(', model%n_x, '(1x,f6.1))'
    do i = 1, model%n_y
       write(*,fmt=rowfmt) model%temperature(i,:)
    end do
  end subroutine print_values

end module heat
