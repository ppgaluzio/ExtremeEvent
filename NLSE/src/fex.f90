! ******************************************************************
! F E X

subroutine fex(neq,t,psir,psirdot)
  use tipos, only : dp
  use constantes, only : n, epss, xi, g, omega2, vb, k, gamma, wsave,&
       & inc, lensav, work, lenwrk
  implicit none
  integer :: neq, i, ier
  complex(dp), dimension(n), save :: psi, psidot, nl
  real(dp), dimension(neq) :: psir,psirdot
  real(dp) :: t

  print*, psir(1)

  forall(i=1:n)
     psi(i) = cmplx(psir(i), psir(i+n))
  end forall

  call alias(psi)
  call termo_nao_linear

  print*, nl(1)
  print*, psi(1)

  psidot = - xi * ( epss + g*nl - (omega2 + (vb*k)**2 ) * psi ) &
       - gamma * psi

  print*, psidot(1)

  call alias(psidot)

  forall(i=1:n)
     psirdot(i) = real( psidot(i) )
     psirdot(i+n) = aimag( psidot(i) )
  end forall

  pause
  return
contains

  ! ****************************************************************
  ! calcula alias no vetor complexo passado como argumento

  subroutine alias(y)
    implicit none
    integer :: j
    complex(dp), dimension(n) :: y
    forall(j=n/3:2*n/3)
!!$       forall(j=n/4:3*n/4)
       y(j) = (0.0,0.0)
    end forall
    return
  end subroutine alias

  ! ****************************************************************
  ! calcula o termo nao linear

  subroutine termo_nao_linear
    print "('nonlinear')"
    nl = psi
    print *, psi(1), n
    call cfftb(n,nl,wsave)
    ! call cfft1b(n, inc, nl, n, wsave, lensav, work, lenwrk, ier)
    nl = nl / real(n)
    print *, nl(1), ier
    nl = ( real(nl)**2 + aimag(nl)**2 ) * nl
    print *, nl(1)
    call cfftf(n,nl,wsave)
    ! call cfft1f(n, inc, nl, n, wsave, lensav, work, lenwrk, ier)
    nl = nl / real(n)
    print *, nl(1)
    return
  end subroutine termo_nao_linear
end subroutine fex
