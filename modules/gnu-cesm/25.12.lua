help([[
This module loads libraries for building the WRF-Hydro CESM project
the CISL machine Derecho (Cray) using GNU 14.3.0
]])

whatis([===[Loads libraries needed for building the WRF-Hydro CESM project on Derecho with GNU compilers]===])

load("ncarenv/25.10")
load("gcc/14.3.0")
load("cray-libsci/25.03.0")
load("cray-mpich/8.1.32")
load("netcdf-mpi/4.9.3")
load("parallel-netcdf/1.14.1")
load("parallelio/2.6.8")
load("esmf-mpi/8.9.1")
load("gptl/8.1.1")

setenv("CMAKE_Platform","derecho.gnu")
