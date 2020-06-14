! ******************************************************************
! F E X          

subroutine fex(neq,t,psir,psirdot)
  use tipos, only : dp
  use constantes, only : n, epss, xi, g, omega2, vb, k, gamma, wsave
  implicit none
  integer :: neq, i
  complex(dp), dimension(n), save :: psi, psidot, nl
  real(dp), dimension(neq) :: psir,psirdot
  real(dp) :: t

  forall(i=1:n)
     psi(i) = cmplx(psir(i), psir(i+n))
  end forall

  call alias(psi)
  call termo_nao_linear

  psidot = - xi * ( epss + g*nl - (omega2 + (vb*k)**2 ) * psi ) &
       - gamma * psi

  call alias(psidot)

  forall(i=1:n)
     psirdot(i) = real( psidot(i) )
     psirdot(i+n) = aimag( psidot(i) )
  end forall

  return
contains

  ! ****************************************************************
  ! calcula alias no vetor complexo passado como argumento

  subroutine alias(y)
    implicit none
    integer :: j
    complex, dimension(n) :: y
    forall(j=n/3:2*n/3)
!!$       forall(j=n/4:3*n/4)
       y(j) = (0.0,0.0)
    end forall
    return
  end subroutine alias

  ! ****************************************************************
  ! calcula o termo nao linear

  subroutine termo_nao_linear
    nl = psi
    call cfftb(n,nl,wsave)
    nl = ( real(nl)**2 + aimag(nl)**2 ) * nl
    call cfftf(n,nl,wsave)
    nl = nl / real(n)
    return
  end subroutine termo_nao_linear
end subroutine fex
