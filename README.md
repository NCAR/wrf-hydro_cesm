# WRF-Hydro CTSM Coupling
MPAS-Hydro CTSM Coupling is a coupling of [WRF-Hydro](https://github.com/NCAR/wrf_hydro_nwm_public) and [CTSM](github.com/ESCOMP/CTSM)
The coupling mechanism uses [Earth System Modeling Framework](https://earthsystemmodeling.org/)
(ESMF) and the [National Unified Operational Prediction Capability](https://earthsystemmodeling.org/nuopc)
(NUOPC) interoperability layer, also reffered to as a cap.

## Prerequisite Derecho Modules
Load appropriate set of modules, the following are for building with GNU.
```bash
$ ml purge
$ ml ncarenv/25.10 gcc/14.3.0 cmake/3.31.8  hdf5/1.14.6 netcdf/4.9.3 esmf/8.9.0 cray-mpich/8.1.32 parallelio/2.6.6

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

### CTSM Lilac Build
/glade/work/felfelan/CTSM/cases/ctsm_wrfhydro/README.FF
```bash
$ cd scr/ctsm_src
$ ./bin/git-fleximod update
$ git submodule update --init --recursive
$ ./lilac/build_ctsm --machine derecho --compiler gnu /glade/derecho/scratch/${USER}/ctsm_build_dir
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
