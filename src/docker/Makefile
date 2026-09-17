image ?= cesm-wrf-hydro
notebook_image ?= $(image)-notebook
dev_uid ?= $(shell id -u)
dev_gid ?= $(shell id -g)

.PHONY: all build build-notebook

all: build

build:
	docker build -t "$(image)" .

build-notebook: build
	docker build -f Dockerfile.notebook \
	  --build-arg BASE_IMAGE="$(image)" \
	  --build-arg DEV_UID="$(dev_uid)" --build-arg DEV_GID="$(dev_gid)" \
	  -t "$(notebook_image)" ..
