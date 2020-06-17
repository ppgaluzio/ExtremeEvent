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
  use energy_calculator, only : calcula_energia

  use constantes, only : n, tran, tfinal, ts, tstep, tperfil
  use constantes, only : wsave, vb, x
  use constantes, only : inicializa_ctes

  use integrador, only : neq, itol, rtol, atol, itask, istate, iopt,&
       & rwork, lrw, iwork, liw, mf, jt
  use integrador, only : inicializa_lsoda

  implicit none

  external fex
  complex(dp), parameter :: xi = ( 0.0, 1.0 )
  complex(dp), dimension(n) :: psi, psimedio
  real(dp), dimension(neq) :: psir
  integer :: i, nmedio
  real(dp) :: tout, t, random, tcount

  open(1,file='ctes.dat')
  open(2,file='perfil.dat')

  ! Inicializa as ctes do programa
  call inicializa_ctes
  call inicializa_lsoda

  ! Condições iniciais da variável complexa
  call random_seed()
  psi = 1.0d-5
  call random_number( random )
!  random = 0.5
  psi(1) = random
  call random_number( random )
!  random = 0.75
  psi(2) = 0.1 * random
  psi(n) = psi(2)
  call random_number( random )
!  random = 0.3
  psi(3) = 0.01 * random
  psi(n-1) = psi(3)

  ! inicializa a variável real
  forall(i=1:n)
     psir(i) = real( psi(i) )
     psir(i+n) = aimag( psi(i) )
  end forall

!!$  ! condição inicial no espaço real (soliton solution)
!!$  do i = 1, n
!!$     psi(i) = (sqrt(2.0)/cosh(sqrt(2.0)*x(i)))*exp(xi*0.05*x(i))
!!$     psi(i) = sqrt(1.5) * exp( -xi * (-0.17683882) ) &
!!$          + 1.0d-3 * exp( xi * vb * x(i) )
!!$  enddo
!!$  call cfftf(n,psi,wsave)
!!$  psi = psi / real(n)

  ! ****************************************************************
  ! ****************************************************************

  ! Começa integração
  t = 0.0
  transiente : do while( t < tran )
     tout = t + tstep
!!$     call dlsode(fex,neq,psir,t,tout,itol,rtol,atol,itask,istate,iopt,&
!!$          rwork,lrw,iwork,liw,jt,mf)
     call dlsoda(fex,neq,psir,t,tout,itol,rtol,atol,itask,istate,iopt,&
          rwork,lrw,iwork,liw,mf,jt)
  end do transiente

  print "('FIM DO TRANSIENTE')"

  ! ****************************************************************
  ! ****************************************************************
  ! Integra os pontos propriamente ditos

  psimedio = 0.0_dp
  nmedio = 0
  tcount = 0.0_dp
  integra : do while( t < tfinal )
     tout = t + tstep
     tcount = tcount + tstep
     call dlsoda(fex,neq,psir,t,tout,itol,rtol,atol,itask,istate,iopt,&
          rwork,lrw,iwork,liw,mf,jt)

     escreve : if ( tcount > ts ) then
        write(1,"(6(x,f32.16))") t,calcula_energia(psir), psir(1)

        forall(i=1:n)
           psi(i) = cmplx( psir(i), psir(i+n) )
        end forall

        psimedio = psimedio + psi
        nmedio = nmedio + 1

        perfil : if ( t > (tfinal-tperfil)) then

           call cfftb(n,psi,wsave)

           do i = 1, n
              write(2,"(3(f20.10,x))") t, x(i), abs(psi(i))
           end do
        end if perfil
        tcount = 0.0
     end if escreve

  end do integra

  close(1)
  close(2)

  open(3,file='kmedio.dat')
  do i = 1, n
     write(3,"(f32.16)") abs(psimedio(i)) / real( nmedio )
  end do

  close(3)

  stop
end program integracao
