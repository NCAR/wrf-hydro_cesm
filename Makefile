dir=$(SCRATCH)/cases/hydro-test2
runblddir=$(SCRATCH)/hydro-test2

compiler=intel
compiler=gnu

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

clean:
	rm -rf $(dir) $(testdir) $(runblddir)
