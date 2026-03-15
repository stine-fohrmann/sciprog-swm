#  Makefile:

.SUFFIXES: .o .f90

.f90.o:
	$(FC) -c $(FFLAGS) $(LDFLAGS) $<

.f90:
	$(FC) -o $@ $(FFLAGS) $(LDFLAGS) $<

FC = gfortran
FFLAGS = -O3
INCLUDES := #-I$(shell /sw/bookworm-x64/io_gcc/netcdf-c-4.9.2-fortran-4.6.1-cxx4-4.3.1/bin/nf-config --includedir)
LIBS := #$(shell /sw/bookworm-x64/io_gcc/netcdf-c-4.9.2-fortran-4.6.1-cxx4-4.3.1/bin/nf-config --flibs)
LDR = gfortran
LDFLAGS = $(INCLUDES)
CC = gcc

SHELL = /bin/sh

SBIN = swm.x

SSRCS = swm.f90 init.f90 integ_u.f90 integ_v.f90 integ_h.f90 bound.f90 outcdf.f90

SOBJS = $(SSRCS:.f90=.o)

$(SBIN): $(SOBJS)
	$(LDR) $(FFLAGS) $(LDFLAGS) -o $(SBIN) $(SOBJS) $(LIBS)

clean:
	rm -rf *.o swm.x
