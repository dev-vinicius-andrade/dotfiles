BINARY_NAME=dotfiles
OUTPUT_DIR=.bin
ifeq ($(OS),Windows_NT)
    RM = if exist "$(OUTPUT_DIR)" rmdir /s /q "$(OUTPUT_DIR)"
else
    RM = if [ -d "$(OUTPUT_DIR)" ]; then rm -rf "$(OUTPUT_DIR)"; fi
endif
clean:
	@$(RM)
build:
	go build -o $(OUTPUT_DIR)/$(GOARCH)/$(GOOS)/$(BINARY_NAME) main.go
build_linux:
	@$(MAKE) build GOOS=linux GOARCH=386
	@$(MAKE) build GOOS=linux GOARCH=amd64
build_windows:
	@$(MAKE) build GOOS=windows GOARCH=386 BINARY_NAME=$(BINARY_NAME).exe
	@$(MAKE) build GOOS=windows GOARCH=amd64 BINARY_NAME=$(BINARY_NAME).exe
build_darwin:
	@$(MAKE) build GOOS=darwin GOARCH=amd64
build_freebsd:
	@$(MAKE) build GOOS=freebsd GOARCH=386
	@$(MAKE) build GOOS=freebsd GOARCH=amd64
clean_all:
	@if [ -d "$(OUTPUT_DIR)" ]; then rm -rf $(OUTPUT_DIR); fi
build_all: clean build_linux build_windows build_darwin build_freebsd

