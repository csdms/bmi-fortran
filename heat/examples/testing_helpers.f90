module testing_helpers

contains

  ! Prints a rank 1 array to the console.
  subroutine print_array(array, dims)
    integer :: dims(2)
    real, dimension(product(dims)) :: array
    integer :: i, j

    do j = 1, dims(1)
       do i = 1, dims(2)
          write (*,"(f6.1)", advance="no") array(j + dims(1)*(i-1))
       end do
       write (*,*)
    end do
  end subroutine print_array

end module testing_helpers
