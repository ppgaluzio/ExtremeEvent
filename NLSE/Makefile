I = gfortran  -O3
OPTS = -msse4.2
LODE = /home/paulo/opt/odepack/libode.a
LFFT = /home/paulo/opt/fftpack5.1/src/libfft.a
EXEC = integranls
SRC = src

KURT = integracao.f90
PERFIL = integracao_perfil.f90
DIFF = diff.finite.f90
CTES = constantes.f90
ENER = energy.calculator.f90
TIPOS = tipos.f90
FEX = fex.f90

all: constantes.o diff.finite.o fex.o integracao.o energy.calculator.o tipos.o comp perf

perf:  constantes.o fex.o perfil.o tipos.o
	$(I) constantes.o fex.o perfil.o $(LODE) $(LFFT) $(LEST) -o PERFIL
	@echo "***********************************************************************"
	@echo "PERFIL OK"
	@echo

comp: constantes.o diff.finite.o fex.o integracao.o energy.calculator.o tipos.o
	$(I) constantes.o diff.finite.o fex.o energy.calculator.o integracao.o $(LODE) $(LFFT) $(LEST) -o $(EXEC)
	@echo "***********************************************************************"
	@echo "COMPILACAO OK"
	@echo

integracao.o: $(SRC)/$(KURT) constantes.o energy.calculator.o tipos.o
	$(I) -c $(SRC)/$(KURT)
	@echo "***********************************************************************"
	@echo "INTEGRACAO OK"
	@echo

perfil.o: $(SRC)/$(PERFIL) constantes.o tipos.o
	$(I) -c $(SRC)/$(PERFIL) -o perfil.o
	@echo "***********************************************************************"
	@echo "INTEGRACAO OK"
	@echo

energy.calculator.o: $(SRC)/$(ENER) constantes.o diff.finite.o tipos.o
	$(I) -c $(SRC)/$(ENER)
	@echo "***********************************************************************"
	@echo "ENERGY OK"
	@echo

fex.o: $(SRC)/$(FEX) constantes.o tipos.o
	$(I) -c $(SRC)/$(FEX)
	@echo "***********************************************************************"
	@echo "FEX OK"
	@echo

diff.finite.o: $(SRC)/$(DIFF) tipos.o
	$(I) -c $(SRC)/$(DIFF)
	@echo "***********************************************************************"
	@echo "DIFF OK"
	@echo

constantes.o: $(SRC)/$(CTES) tipos.o
	$(I) -c $(SRC)/$(CTES)
	@echo "***********************************************************************"
	@echo "CONSTANTES OK"
	@echo

tipos.o: $(SRC)/$(TIPOS)
	$(I) -c $(SRC)/$(TIPOS)
