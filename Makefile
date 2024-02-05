.PHONY: picosdl2
.PHONY: clean

TOOLCHAIN_NAME=pico8-wrapper-toolchain
WORKSPACE_DIR := $(shell pwd)/workspace
PICO_DIR := $(shell pwd)/pico

.build: Dockerfile
	mkdir -p ./workspace
	docker build -t $(TOOLCHAIN_NAME) .
	touch .build

prepare_workspace: .build
	docker run --rm -v "$(PICO_DIR)":/source -v "$(WORKSPACE_DIR)":/destination alpine /bin/sh -c "cp -r /source /destination/pico"

picosdl2: prepare_workspace
	docker run -it --rm -v "$(WORKSPACE_DIR)":/root/workspace $(TOOLCHAIN_NAME) /bin/bash

clean:
	docker rmi $(TOOLCHAIN_NAME)
	rm -f .build
