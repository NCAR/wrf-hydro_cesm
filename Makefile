np=4

.PHONY: build

all: build

build:
	WRF_HYDRO_CTSM_NUOPC=ON ESMX_Builder --verbose --build-jobs=$(np) --build-type=Debug \
          --cmake-args=-DCMAKE_Fortran_FLAGS=-I/glade/derecho/scratch/soren/ctsm_build_dir/case/bld/gnu/mpich/nodebug/nothreads/CDEPS/dlnd
# \ -I/glade/derecho/scratch/soren/ctsm_build_dir/case/bld/gnu/mpich/nodebug/nothreads/CDEPS/datm
	  # --cmake-args=-DCMAKE_Fortran_FLAGS=-I/glade/derecho/scratch/soren/ctsm_build_dir/case/bld/gnu/mpich/nodebug/nothreads/CDEPS/datm
	# CMAKE_Fortran_FLAGS="-I/glade/derecho/scratch/soren/ctsm_build_dir/case/bld/gnu/mpich/nodebug/nothreads/CDEPS/dlnd"
	# THIS CMAKE-ARGS MADE DATM WORK when disable_comps: ESMX_Data in .yaml
	# bash ./hack_build_exe.sh
	# cp build/ctsm_hydro .

clean:
	rm -rf build/ install/* ctsm_hydro

	# PIO=${NCAR_ROOT_PARALLELIO} \
	# PnetCDF_ROOT=${NCAR_ROOT_PARALLEL_NETCDF} \
	# PnetCDF_MODULE_DIR=${NCAR_ROOT_PARALLEL_NETCDF}/include
