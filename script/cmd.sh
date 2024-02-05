#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
TMP_DIR="/tmp/sdl2_miyoo"
WORKSPACE_DIR="/root/workspace"
REPO_URL="https://github.com/XK9274/sdl2_miyoo"
BRANCH="pico8"
TOOLCHAIN_URL="https://github.com/steward-fu/archives/releases/download/miyoo-mini/toolchain.tar.gz"
LIB_SOURCE_PATH="$WORKSPACE_DIR/sdl2_miyoo/build/.libs/libSDL2-2.0.so.0.18.2"
LIB_DEST_DIR="$WORKSPACE_DIR/build/lib"
LIB_DEST_PATH="$LIB_DEST_DIR/libSDL2-2.0.so.0"

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$LIB_DEST_DIR"

if [ ! -d "$TMP_DIR" ]; then
    echo "Cloning sdl2_miyoo repository..."
    git clone --depth=1 "$REPO_URL" -b "$BRANCH" "$TMP_DIR"
    cp -r "$TMP_DIR" "$WORKSPACE_DIR/sdl2_miyoo"
fi

printf "${GREEN}=====================================\n"
printf "Toolchain Setup for Miyoo Mini\n"
printf "This build environment relies on Stewards toolchain.\n"
printf "=====================================${NC}\n\n"

if [ ! -f "$WORKSPACE_DIR/toolchain.tar.gz" ]; then
    printf "${YELLOW}toolchain.tar.gz not found, downloading now...${NC}\n"
    wget "$TOOLCHAIN_URL" -O "$WORKSPACE_DIR/toolchain.tar.gz"
    printf "${GREEN}Extracting toolchain...${NC}\n"
    tar xf "$WORKSPACE_DIR/toolchain.tar.gz" -C "$WORKSPACE_DIR"
fi

for dir in mmiyoo prebuilt; do
    if [ -d "$WORKSPACE_DIR/$dir" ]; then
        printf "${GREEN}Copying $dir dir to /opt...${NC}\n"
        cp -r "$WORKSPACE_DIR/$dir" /opt/
    else
        printf "${RED}$dir folder not found.${NC}\n"
    fi
done

export PATH="/opt/mmiyoo/bin/:$PATH"

printf "${YELLOW}Configuring environment...${NC}\n"
if [ -d "$WORKSPACE_DIR/sdl2_miyoo/" ] && [ -f "$WORKSPACE_DIR/sdl2_miyoo/run.sh" ]; then
    cd "$WORKSPACE_DIR/sdl2_miyoo"
    chmod -R a+w+x *
    ./run.sh config
else
    printf "${RED}run.sh script not found.${NC}\n"
fi

make -j$(( $(nproc) - 2 ))

if [ -f "$LIB_SOURCE_PATH" ]; then
    cp "$LIB_SOURCE_PATH" "$LIB_DEST_PATH"
    printf "${GREEN}The library has been created and is located at: ${NC}$LIB_DEST_PATH\n"
    printf "${GREEN}You can now make changes to the source and recompile with:${NC} make -j$(( $(nproc) - 2 ))\n"
    printf "${GREEN}To reconfigure, run:${NC} /root/workspace/sdl2_miyoo/run.sh config\n"
else
    printf "${RED}The library file was not found. Ensure the build process completed successfully.${NC}\n"
fi

exec "$@"
