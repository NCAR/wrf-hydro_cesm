Build
=====

Modules
-------
Load appropriate set of modules, the following is for building with GNU on Derecho.

.. code-block:: bash

   $ ml use modules
   $ ml purge
   $ ml gnu-cesm

The user can also build the following list of prerequisites:

* ncarenv
* gcc
* cray-libsci
* cray-mpich
* netcdf-mpi
* parallel-netcdf
* parallelio
* esmf-mpi
* gptl
* Python libraries
  * Matplotlib
  * Xarray


Source Code
-----------
Note, do not do `--recursive` when initiliazing the CTSM submodule.
CTSM uses git-fleximod to handle its submodules and initializing
recursively with `git` will cause problems.

.. code-block:: bash

   $ git clone git@github.com:NCAR/wrf-hydro_cesm.git
   $ cd wrf-hydro_cesm
   $ git submodule update --init
   $ cd src/ctsm
   $ ./bin/git-fleximod update


Updating CESM Source
--------------------

It is good to check the status before updating CESM, from the top
wrf-hydro_cesm directory run the following

.. code-block:: bash

   $ git pull
   $ cd src/ctsm
   $ ./bin/git-fleximod status
   $ ./bin/git-fleximod update


Quick Start
-----------
The `Quick Start` instructions shows how the `Makefile` is used to condense
the steps for setup, building, and running. Load modules, then run

.. code-block:: bash

   $ make setup
   $ make preview
   $ make build
   the build will not work using the Makefile, copy and paste this command
   $ cd path/to/build ; ./case.build --verbose
   $ make run


Manual Steps
------------

Setup
~~~~~

.. code-block:: bash

   $ export dir=/glade/derecho/scratch/$USER/cases/hydro-test
   $ cd cime/scripts/ && \
   $ ./create_newcase \
      --case ${dir} \
      --mach derecho \
      --compiler gnu \
      --compset I2000Ctsm50NwpSpNldasWRFHydro \
      --res nldas2_rnldas2_mnldas2 \
      --run-unsupported \
      --project ${DERECHO_PROJECT_TAG} \
      --pesfile src/ctsm/ctsm_repo/components/wrfhydro/src/CPL/CESM_cpl/cime_config/config_pes.xml
   $ cd ${dir} && \
      ./xmlchange STOP_OPTION=nhours,STOP_N=1,ROF_NCPL=24 && \
      ./case.setup

Build
~~~~~

.. code-block:: bash

   $ dir=$SCRATCH/cases/hydro-test
   $ cd $(dir)
   $ ./case.build --verbose

   preview testcase
   $ ./preview_namelists
   $ ./preview_run
