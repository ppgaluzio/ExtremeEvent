module energy_calculator
  use tipos, only : dp
  use constantes, only : n, nctes, dx, l, omega2, epssi, g, wsave
  use finite_diff, only : derivada
  implicit none
  complex(dp), dimension(n) :: psi
  
  save
  private
  public :: calcula_energia
contains
  
  function calcula_energia(psir) result(energia)
    real(dp), dimension(:), intent(in) :: psir
    real(dp), dimension(nctes) :: energia

    complex(dp) :: diff
    real(dp) :: psi2, psi4, psix2, psipls, p
    integer :: i

    if ( size(psir) /= 2*n ) then
       write(0,"('ERRO -- em calcula_energia -- wrong psir size')")
       call exit(3)
    end if
    
    forall(i=1:n)
       psi(i) = cmplx( psir(i), psir(i+n) )
    end forall

    call cfftb(n,psi,wsave)
    
    psi2 = 0.0
    psi4 = 0.0
    psix2 = 0.0
    psipls = 0.0
    p = 0.0
    do i=1,n
       psi2 = psi2 + abs(psi(i))**2
       psi4 = psi4 + abs(psi(i))**4
       psipls = psipls + 2.0 * real(psi(i))
       diff = derivada(i,psi,dx)
       psix2 = psix2 + abs(diff)**2
       p = p + real(psi(i)) * aimag(diff) - aimag(psi(i)) * real(diff)
    end do
    energia(1) = psi2 * dx / l
    energia(2) = ( - psix2 + 0.5 * g * psi4 - omega2 * psi2 ) * dx / l
    energia(3) = ( psix2 - 0.5 * g * psi4 + omega2 * psi2 - epssi * psipls) * dx / l
    energia(4) = p * dx / l

    return
  end function calcula_energia
end module energy_calculator
