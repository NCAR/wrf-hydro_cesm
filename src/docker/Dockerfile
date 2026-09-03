# syntax=docker/dockerfile:1

ARG ESMF_VERSION=8.9.1
FROM esmf/esmf-build-release:${ESMF_VERSION}

LABEL org.opencontainers.image.title="WRF-Hydro CTSM build environment"
LABEL org.opencontainers.image.source="https://github.com/NCAR/wrf-hydro_cesm"

SHELL ["/bin/bash", "-lc"]

ARG PNETCDF_VERSION=1.14.1
ARG PNETCDF_PREFIX=/home/dev/install/pnetcdf

USER root

# The ESMF base image supplies a mutually compatible GNU, OpenMPI, HDF5,
# NetCDF-C, NetCDF-Fortran, CMake, and ESMF stack. Install the remaining
# tools needed by CIME and the WRF-Hydro make-based build.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        autoconf \
        automake \
        ca-certificates \
        csh \
        file \
        git \
        libblas-dev \
        liblapack-dev \
        libtool \
        libxml2-utils \
        m4 \
        make \
        perl \
        python3 \
        wget \
    && rm -rf /var/lib/apt/lists/*

USER dev

# PnetCDF must be built with the same MPI wrappers used by ESMF and NetCDF.
# CTSM builds the ParallelIO version pinned by git-fleximod, so a second PIO
# installation in this image would be unused and risks a version mismatch.
RUN mkdir -p "${PNETCDF_PREFIX}" \
    && cd /tmp \
    && wget --quiet \
        "https://parallel-netcdf.github.io/Release/pnetcdf-${PNETCDF_VERSION}.tar.gz" \
    && tar -xzf "pnetcdf-${PNETCDF_VERSION}.tar.gz" \
    && cd "pnetcdf-${PNETCDF_VERSION}" \
    && MPICC=mpicc MPICXX=mpicxx MPIF77=mpifort MPIF90=mpifort \
        M4="$(command -v m4)" \
        ./configure --prefix="${PNETCDF_PREFIX}" --enable-shared \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf \
        "/tmp/pnetcdf-${PNETCDF_VERSION}" \
        "/tmp/pnetcdf-${PNETCDF_VERSION}.tar.gz"

# ESMF images from 8.6.1 onward expose their Spack environment through this
# view. Keep these paths explicit so non-interactive CIME build processes see
# the same compiler and library stack as login shells.
ENV ESMF_STACK_VIEW=/home/dev/spack/var/spack/environments/esmf/.spack-env/view
ENV NETCDF_PATH=${ESMF_STACK_VIEW}
ENV NETCDF=${ESMF_STACK_VIEW}
ENV PNETCDF_PATH=${PNETCDF_PREFIX}
ENV PNETCDF=${PNETCDF_PREFIX}
ENV PATH=${PNETCDF_PREFIX}/bin:${ESMF_STACK_VIEW}/bin:${PATH}
ENV CMAKE_PREFIX_PATH=${PNETCDF_PREFIX}:${ESMF_STACK_VIEW}
ENV CPATH=${PNETCDF_PREFIX}/include:${ESMF_STACK_VIEW}/include
ENV LIBRARY_PATH=${PNETCDF_PREFIX}/lib:${ESMF_STACK_VIEW}/lib:${ESMF_STACK_VIEW}/lib64
ENV LD_LIBRARY_PATH=${PNETCDF_PREFIX}/lib:${ESMF_STACK_VIEW}/lib:${ESMF_STACK_VIEW}/lib64

WORKDIR /workspace

# Fail the image build early if the inherited scientific stack or PnetCDF is
# unavailable. ESMFMKFILE is initialized by the base image's login shell.
RUN command -v mpicc \
    && command -v mpifort \
    && command -v nc-config \
    && command -v nf-config \
    && command -v pnetcdf_version \
    && test -n "${ESMFMKFILE:-}" \
    && test -f "${ESMFMKFILE}" \
    && pnetcdf_version
