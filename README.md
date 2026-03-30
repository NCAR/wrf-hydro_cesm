# WRF-Hydro CTSM Coupling
MPAS-Hydro CTSM Coupling is a coupling of [WRF-Hydro](https://github.com/NCAR/wrf_hydro_nwm_public) and [CTSM](github.com/ESCOMP/CTSM)
The coupling mechanism uses [Earth System Modeling Framework](https://earthsystemmodeling.org/)
(ESMF) and the [National Unified Operational Prediction Capability](https://earthsystemmodeling.org/nuopc)
(NUOPC) interoperability layer, also reffered to as a cap.

## Prerequisite Derecho Modules
Load appropriate set of modules, the following are for building with GNU.
```bash
$ ml purge
$ ml ncarenv/25.10 gcc/14.3.0 cmake/3.31.8  hdf5/1.14.6 netcdf/4.9.3 esmf/8.9.0 cray-mpich/8.1.32

NOTE: esmf/8.9.1 currently is unable to load an MPI implementation
```

## Obtain Source
```bash
$ git clone --recursive-submodule git@github.com:NCAR/wrf-hydro_ctsm.git
$ git clone --recursive-submodule git@github.com:scrasmussen/ctsm.git
$ cd wrf-hydro_ctsm
$ ln -s $(pwd)/../ctsm src/ctsm_src
```

## Build
MPAS-Hydro couples using the ESMX infrastructure.
Note, the build instructions are specific to Derecho at the current moment.

### CTSM Build
```bash
$ cd scr/ctsm_src
$ ./bin/git-fleximod update
$ git submodule update --init --recursive
$ ./lilac/build_ctsm --machine derecho --compiler gnu /glade/derecho/scratch/${USER}/ctsm_build_dir
```


## Definitions

| Acronym   | Description                                                         |
|-----------|---------------------------------------------------------------------|
| **CIME**  | Common Infrastructure for Modeling the Earth                        |
|           | The project describes it as the infrastructure layer that provides  |
|           | a Case Control System for configuring, compiling, and running Earth |
|           | system models, along with a framework for system testing            |
| **LILAC** | Lightweight Infrastructure for Land-Atmosphere Coupling             |
|           | lightweight coupling layer built on top of ESMF so atmosphere       |
|           | models can call CTSM directly and a set of Python-based tools for   |
|           | building CTSM and creating its runtime inputs in that coupling mode |
