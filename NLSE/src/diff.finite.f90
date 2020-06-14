! calcula derivada utilizando o método das diferençãs finitas

module finite_diff
  use tipos, only : dp
  implicit none

  integer, parameter :: ordem = 6
  integer, parameter :: ordem2 = 3
  real(dp), dimension(ordem+1), parameter :: fd = &
       (/ -1./60., 3./20., -3./4., 0.0, 3./4., -3./20., 1./60. /)
  
  save
  private
  public derivada

contains

  ! ****************************************************************
  function derivada(i,y,dx) result(diff)
    integer, intent(in) :: i
    complex(dp), dimension(:), intent(in) :: y
    real(dp), intent(in) :: dx

    complex(dp) :: diff
    integer :: n, j, k

    n = size(y)
    diff = cmplx( 0.0, 0.0 )
    
    do j = 0, ordem
       k = i - ordem2 + j

       ! Usa condições de contorno periódicas
       if ( k > n ) then
          k = k - n
       else if ( k < 1 ) then
          k = n + k
       end if
       
       diff = diff + fd(j+1) * y(k)
    end do

    diff = diff / dx
    return
  end function derivada
end module finite_diff
