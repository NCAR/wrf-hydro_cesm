dir=$(SCRATCH)/cases/hydro-test
runblddir=$(SCRATCH)/hydro-test

# compiler=intel
compiler=gnu

notebook_file=src/notebooks/build.ipynb
notebook_env=wrf-hydro-nb

all: setup

help:
	cd src/ctsm/cime/scripts/ && \
	./create_newcase --help
setup:
	cd src/ctsm/cime/scripts/ && \
	./create_newcase \
	  --case $(dir) \
	  --mach derecho \
	  --compiler $(compiler) \
	  --compset I2000Ctsm50NwpSpNldasWRFHydro \
	  --res nldas2_rnldas2_mnldas2 \
	  --run-unsupported \
	  --project NWCA0002 \
	  --pesfile $(PWD)/src/ctsm/components/wrfhydro/src/CPL/CESM_cpl/cime_config/config_pes.xml
	cd $(dir) && \
	./xmlchange STOP_OPTION=nhours,STOP_N=1,ROF_NCPL=24 && \
	./case.setup

preview:
	cd $(dir) && ./preview_namelists

build:
	@echo "Build won't work from Makefile, copy and paste this command"
	@echo "$$ cd $(dir) ; ./case.build --verbose"

run:
	cd $(dir) && \
	./case.submit

ls:
	ls $(dir)

info:
	@echo "--- wrfhydro ---"
	./src/ctsm/cime/scripts/query_config --compsets | grep WRFHydro
	./src/ctsm/cime/scripts/query_config --grids | egrep 'wrfhydro'

# first case, was recommended
setup-first-recommended:
	cd src/ctsm/cime/scripts/ && \
	./create_newcase \
	  --case $(dir) \
	  --mach derecho \
	  --compiler $(compiler) \
	  --compset I2000Ctsm50NwpSpNldas \
	  --res nldas2_rnldas2_mnldas2 \
	  --project NWCA0002 \
	  --pesfile $(PWD)/src/ctsm/ctsm_repo/components/wrfhydro/src/CPL/CESM_cpl/cime_config/config_pes.xml
	cd $(dir) && \
	./xmlchange STOP_OPTION=nhours,STOP_N=1,ROF_NCPL=24 && \
	./case.setup

# Local development only. On NCAR JupyterHub the hub already serves the
# notebook, just open $(notebook_file) there instead of running this.
notebook:
	@command -v jupyter >/dev/null || { \
	  echo "jupyter is not on PATH."; \
	  echo "One-time setup:  make notebook-env"; \
	  echo "then:            conda activate $(notebook_env) && make notebook"; \
	  exit 1; \
	}
	jupyter lab $(notebook_file)

notebook-env:
	conda create -y -n $(notebook_env) python=3.12 jupyterlab
	@echo "Created '$(notebook_env)'. Now run:"
	@echo "  conda activate $(notebook_env) && make notebook"


clean:
	rm -rf $(dir) $(testdir) $(runblddir)
