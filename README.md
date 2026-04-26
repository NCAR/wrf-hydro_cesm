# WRF-Hydro CTSM Coupling
MPAS-Hydro CTSM Coupling is a coupling of [WRF-Hydro](https://github.com/NCAR/wrf_hydro_nwm_public) and [CTSM](github.com/ESCOMP/CTSM)
The coupling mechanism uses [Earth System Modeling Framework](https://earthsystemmodeling.org/)
(ESMF) and the [National Unified Operational Prediction Capability](https://earthsystemmodeling.org/nuopc)
(NUOPC) interoperability layer, also reffered to as a cap.

## Prerequisite Derecho Modules
Load appropriate set of modules, the following are for building with GNU.
```bash
$ ml purge
$ ml ncarenv/25.10 ncarenv-basic/25.10 gcc/14.3.0  cray-libsci/25.03.0
     cray-mpich/8.1.32 netcdf-mpi/4.9.3 parallel-netcdf/1.14.1
     parallelio/2.6.8 esmf-mpi/8.9.1
```

## Setup Source
```bash
$ cd src/ctsm
$ ./bin/git-fleximod update
$ git submodule update --init --recursive

# Fleximod uses tags, do the following to get developement branches
$ cd ccs_config && git remote add wrfhydro git@github.com:scrasmussen/ccs_config_cesm.git
$ git fetch wrfhydro && git checkout wrf-hydro-cesm && cd ..

$ cd cime && git remote add wrfhydro git@github.com:scrasmussen/cime.git
$ git fetch wrfhydro && git checkout wrf-hydro-cesm && cd ..

$ cd cime && git remote add wrfhydro git@github.com:scrasmussen/cime.git
$ git fetch wrfhydro && git checkout wrf-hydro-cesm && cd ..

$ cd components/wrfhydro && git checkout wrf-hydro-cesm && cd ../..
```

## Setup, Build, Run
### Setup
```bash
$ dir=$SCRATCH/cases/hydro-test
$ cd cime/scripts/ && \
$ ./create_newcase \
   --case $(dir)-wrfh \
   --mach derecho \
   --compiler gnu \
   --compset I2000Ctsm50NwpSpNldasWRFHydro \
   --res nldas2_rnldas2_mnldas2 \
   --run-unsupported \
   --project NWCA0002 \
   --pesfile src/ctsm/ctsm_repo/components/wrfhydro/src/CPL/CESM_cpl/cime_config/config_pes.xml
$ cd $(dir)-wrfh && \
   ./xmlchange STOP_OPTION=nhours,STOP_N=1,ROF_NCPL=24 && \
   ./case.setup
```

### Build
```bash
$ dir=$SCRATCH/cases/hydro-test
$ cd $(dir)
$ ./case.build --verbose

# preview testcase
$ ./preview_namelists
$ ./preview_run
```

### Run
```bash
$ dir=$SCRATCH/cases/hydro-test
$ ./case.submit
```

## Definitions

| Acronym   | Description                                                         |
|-----------|---------------------------------------------------------------------|
| **CIME**  | **Common Infrastructure for Modeling the Earth**                    |
|           | The project describes it as the infrastructure layer that provides  |
|           | a Case Control System for configuring, compiling, and running Earth |
|           | system models, along with a framework for system testing            |
| **LILAC** | **Lightweight Infrastructure for Land-Atmosphere Coupling**         |
|           | lightweight coupling layer built on top of ESMF so atmosphere       |
|           | models can call CTSM directly and a set of Python-based tools for   |
|           | building CTSM and creating its runtime inputs in that coupling mode |




# MizuRoute
The reach-based river routing model [mizuRoute](https://github.com/ESCOMP/mizuRoute) is currently the river coupling model for CTSM

## mizuRoute exports to CTSM / mediator
| Variable       | Brief description                               | Notes                                                                                                                         |
| -------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `Forr_rofl`    | Liquid runoff sent from river to coupler        | Built from liquid direct-to-ocean runoff plus liquid routed discharge at outlet points.                                       |
|                |                                                 | In the no-ice-runoff option, liquid and ice contributions are combined into this field. The code comments label it as [mm/s]. |
| `Forr_rofi`    | Frozen or ice runoff sent from river to coupler | Built from solid direct-to-ocean runoff plus solid routed discharge at outlets. If ice_runoff is off, this is set to zero.    |
| `Flrr_flood`   | Flooding flux from river back to land           | Represents floodplain water returned to land. In mizuRoute it is taken from ctl%flood; the code comment says                  |
|                |                                                 | “floodplain volume per HRU area [mm/s]”. Sign convention is important: because positive is land → rof,                        |
|                |                                                 | water going rof → land is exported as negative. CTSM flips the sign on import so it becomes water added to land.              |
| `Flrr_volr`    | Total river water storage seen by land          | Exported from ctl%volr; code comment says “volume (channel+floodplain) per HRU area [m]”.                                     |
|                |                                                 | CTSM multiplies by gridcell area to recover an absolute volume.                                                               |
| `Flrr_volrmch` | Main-channel river storage seen by land         | Intended to be the channel-only storage per HRU area [m], but in the current file it is actually set                          |
|                |                                                 | equal to ctl%volr, the same value used for Flrr_volr. So in the present source these two exports are identical here.          |
## mizuRoute imports from CTSM / mediator
| Variable      | Brief description                                       | Notes                                                                                                     |
| ------------- | ------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| `Flrl_rofsur` | Surface liquid runoff from land to river                | mizuRoute reads this into `ctl%qsur(:,nliq)`. The coupling comments say land sends runoff in `kg/m2/s`,   |
|               |                                                         | equivalent to `mm/s`, and mizuRoute then converts depth-rate runoff to routed flow internally using area. |
|               |                                                         | In CTSM this comes from `qflx_rofliq_qsur_grc`.                                                           |
| `Flrl_rofgwl` | Groundwater drainage / groundwater runoff to river      | mizuRoute reads this into `ctl%qgwl(:,nliq)`. CTSM exports it from `qflx_rofliq_qgwl_grc`.                |
| `Flrl_rofsub` | Subsurface liquid runoff to river                       | mizuRoute reads this into `ctl%qsub(:,nliq)`. CTSM forms it as the sum of subsurface drainage             |
|               |                                                         | and perched drainage, and adds hillslope stream runoff when hillslope routing is enabled.                 |
| `Flrl_rofi`   | Ice runoff from land to river                           | mizuRoute reads this into the surface-runoff slot for the ice tracer, `ctl%qsur(:,nice)`.                 |
|               |                                                         | CTSM exports it from `qflx_rofice_grc`.                                                                   |
| `Flrl_irrig`  | Irrigation withdrawal flux applied to river storage     | mizuRoute reads this into `ctl%qirrig(:)`. CTSM exports it with a minus sign because                      |
|               |                                                         | it is “irrigation flux to be removed from main channel storage.”                                          |
