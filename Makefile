.PHONY: picosdl2
.PHONY: clean
	
TOOLCHAIN_NAME=pico8-wrapper-toolchain
WORKSPACE_DIR := $(shell pwd)/workspace

.build: Dockerfile
	mkdir -p ./workspace
	docker build -t $(TOOLCHAIN_NAME) .
	touch .build

picosdl2: .build
	docker run -it --rm -v "$(WORKSPACE_DIR)":/root/workspace $(TOOLCHAIN_NAME) /bin/bash

clean:
	docker rmi $(TOOLCHAIN_NAME)
	rm -f .build