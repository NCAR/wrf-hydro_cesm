.PHONY: all build open clean

sourcedir = userguide
builddir  = _build/html

# recursive wildcard
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

source_files = $(call rwildcard,$(sourcedir),*.rst *.rest *.css *.py)

all: build

build: $(builddir)/index.html

$(builddir)/index.html: $(source_files)
	@echo Building readthedocs documentation
	sphinx-build -b html $(sourcedir) $(builddir)

open: build
	open $(builddir)/index.html

clean:
	rm -rf _build
