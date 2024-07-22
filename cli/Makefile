ifeq ($(OS),Windows_NT)
	OUTPUT_DIR=.\.bin
    MKDIR = if not exist "$(subst /,\,$(1))" mkdir $(subst /,\,$(1))
    CP = robocopy $(subst /,\,$(2)) $(subst /,\,$(3)) /E /COPY:DAT /R:0 /NFL /NDL /NJH /NJS /NP
	LS = dir /a /w
	
else
	OUTPUT_DIR=./.bin
    MKDIR = mkdir -p $(1)
    CP = rsync -a $(2)/ $(3)
	LS = ls -lha
endif

define RUN_BUILD
	@echo "Building $(1) $(2) $(3) $(4)..."
	cd $(1) && $(MAKE) $(2)
	cd .. && $(call CP,$(3),$(4))
endef
print_os:
	@echo "Operating System: $(OS) Current Directory: $(CURRENT_DIR)"

run_build: print_os
	$(call RUN_BUILD,$(FOLDER),$(TARGET),$(FOLDER)/$(BIN_SOURCE),$(BIN_OUTPUT))

clean:
	cd dotfiles && $(MAKE) clean && cd ..

build:
	$(MAKE) run_build FOLDER=./dotfiles TARGET=build BIN_SOURCE=.bin BIN_OUTPUT=$(OUTPUT_DIR)

build_linux:
	$(MAKE) run_build FOLDER=./dotfiles TARGET=build_linux BIN_SOURCE=.bin BIN_OUTPUT=$(OUTPUT_DIR)

build_windows:
	$(MAKE) run_build FOLDER=./dotfiles TARGET=build_windows BIN_SOURCE=.bin BIN_OUTPUT=$(OUTPUT_DIR)

build_darwin:
	$(MAKE) run_build FOLDER=./dotfiles TARGET=build_darwin BIN_SOURCE=.bin BIN_OUTPUT=$(OUTPUT_DIR)

build_freebsd:
	$(MAKE) run_build FOLDER=./dotfiles TARGET=build_freebsd BIN_SOURCE=.bin BIN_OUTPUT=$(OUTPUT_DIR)

clean_all:
	cd dotfiles && $(MAKE) clean_all && cd ..

build_all: clean build_linux build_windows build_darwin build_freebsd