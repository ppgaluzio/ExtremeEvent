! **************************************************************** !
! **************************************************************** !
!                                                                  !
!                    I N T E G R A Ç Ã O                           !
!                   ---------------------                          !
!                                                                  !
! **************************************************************** !
! **************************************************************** !

! BY: Paulo Paneque Galuzio

! DESCRIPTION: This program simply integrates the nonlinear
!  schroedinger equation, using the pseudospectral method

program integracao

  use tipos, only : dp

  use constantes, only : n, tran, tfinal, ts, tstep, tperfil
  use constantes, only : wsave, vb, x
  use constantes, only : inicializa_ctes

  use integrador, only : neq, itol, rtol, atol, itask, istate, iopt,&
       & rwork, lrw, iwork, liw, mf, jt
  use integrador, only : inicializa_lsoda

  implicit none

  external fex
  complex(dp), parameter :: xi = ( 0.0, 1.0 )
  complex(dp), dimension(n) :: psi
  real(dp), dimension(neq) :: psir
  integer :: i
  real(dp) :: tout, t, random, tcount

  ! Inicializa as ctes do programa
  call inicializa_ctes
  call inicializa_lsoda

  ! Condições iniciais da variável complexa
  call random_seed()
  psi = 1.0d-5
  call random_number( random )
  random = 0.5
  psi(1) = random
  call random_number( random )
  random = 0.75
  psi(2) = 0.1 * random
  psi(n) = psi(2)
  call random_number( random )
  random = 0.3
  psi(3) = 0.01 * random
  psi(n-1) = psi(3)

  ! inicializa a variável real
  forall(i=1:n)
     psir(i) = real( psi(i) )
     psir(i+n) = aimag( psi(i) )
  end forall

  ! ****************************************************************
  ! ****************************************************************
  do while ( t < tran )
     tout = t + tstep
     call dlsoda(fex,neq,psir,t,tout,itol,rtol,atol,itask,istate,iopt,&
          rwork,lrw,iwork,liw,mf,jt)
  end do

  tcount = 0.0_dp
  integra : do while( .true. )
     tout = t + tstep
     tcount = tcount + tstep

     call dlsoda(fex,neq,psir,t,tout,itol,rtol,atol,itask,istate,iopt,&
          rwork,lrw,iwork,liw,mf,jt)

     escreve : if ( tcount > ts ) then

        forall(i=1:n)
           psi(i) = cmplx( psir(i), psir(i+n) )
        end forall
        call cfftb(n,psi,wsave)

        print "(A)", "set yrange [-2:4]"
        print "(A)", "set xrange [-3.14:+3.14]"
        print "(A,f8.2,A)", "set title 'T = ",t,"'"
        print "(A)", "plot '-' w l notitle"
        do i = 1, n
           print "(2(f20.10,x))", x(i), abs(psi(i))
        end do
        print "('e')"
        print "('pause 0.04')"

        tcount = 0.0
     end if escreve

  end do integra

  stop
end program integracao
