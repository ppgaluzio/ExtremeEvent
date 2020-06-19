! Alguns modulos com as declarações de constantes do problema
! **************************************************************** !
!                     C O N S T A N T E S                          !
! **************************************************************** !

! DESCRIPTION: modulo apenas com constantes utilizadas ao longo do
!  programa

module constantes
  use tipos, only : dp
  implicit none

  integer, parameter :: n = 64
  integer, parameter :: nctes = 4

  ! Time constants
  real(dp), parameter :: tstep = 5.0d-2
  real(dp), parameter :: ts = 2.0d-1
  real(dp), parameter :: tran = 0.0
  real(dp), parameter :: tea = 1.0d4
  real(dp), parameter :: tfinal = tran + tea
  real(dp), parameter :: tperfil = 40.0

  real(dp), parameter :: pi2 = 8.0 * atan( 1.0 )
  real(dp), parameter :: omega2 = 0.45
  real(dp), parameter :: g = 2.0
  real(dp), parameter :: gamma = 0.01
  real(dp), parameter :: vb = 0.9
  real(dp), parameter :: epssi = 0.3
  real(dp), parameter :: l = pi2 / vb
  real(dp), parameter :: dx = l / real(n)
  complex(dp), parameter :: xi = ( 0.0, 1.0 )

  integer, parameter :: lensav = 2 * n + int(log(real(n, kind=4)) / log(2.0E+00)) + 4
  integer, parameter :: lenwrk = 2 * n
  integer, parameter :: inc = 1

  real(dp), dimension(n) :: x, k
  real(dp), dimension(4*n+15) :: wsave
  ! real(dp), dimension(lensav) :: wsave
  real(dp), dimension(lenwrk) :: work

  complex(dp), dimension(n) :: epss

  save
  public
  ! Como se trata de um módulo de constantes apenas, então todas as
  !  variáveis podem ser publicas
contains

  subroutine inicializa_ctes
    integer :: i, ier

    call cffti(n, wsave)
    epss = cmplx( epssi, 0.0 )
    call cfftf(n, epss, wsave)
    epss = epss / real( n )
    print*, epss
    pause
    do i = 1, n
       x(i) = l * real( i - n/2 ) / real(n)
    end do
    do i = 1, n/2+1
       k(i) = real(i - 1)
    enddo
    do i = n/2+2, n
       k(i) = real(-(n-(i-1)))
    enddo
    return
  end subroutine inicializa_ctes
end module constantes

! *********************************************************************
! I N T E G R A D O R

module integrador
  use tipos, only : dp
  use constantes, only : n
  implicit none
  integer, parameter :: neq = 2 * n

  integer :: itol,itask,istate,iopt,jt,lrw,liw,mf
  real(dp) :: rtol,atol

!!$  integer, dimension(20) :: iwork
!!$  real(dp), dimension(22+neq*16) :: rwork
  integer, dimension(20+2*neq) :: iwork
  real, dimension(22+2*neq*max(16,2*neq+9)) :: rwork

  save
  public
contains
  subroutine inicializa_lsoda
    itol = 1
    itask = 1
    istate = 1
    iopt = 0
    jt = 2
    mf = 10
    rtol = 1.0d-8
    atol = 1.0d-8
    lrw = 22+2*neq*max(16,2*neq+9)
    liw = 20 + 2 * neq
  end subroutine inicializa_lsoda
end module integrador
