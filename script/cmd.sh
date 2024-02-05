#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
TMP_DIR="/tmp"
WORKSPACE_DIR="/root/workspace"
SDL2_DIR="$WORKSPACE_DIR/sdl2_miyoo"
REPO_URL_SDL="https://github.com/XK9274/sdl2_miyoo"
REPO_URL_NEON="https://github.com/XK9274/neon-arm-library-miyoo.git"
BRANCH_SDL="pico8"
TOOLCHAIN_URL="https://github.com/steward-fu/archives/releases/download/miyoo-mini/toolchain.tar.gz"
LIB_SOURCE_PATH_SDL="$WORKSPACE_DIR/sdl2_miyoo/build/.libs/libSDL2-2.0.so.0.18.2"
INC_DEST_DIR="$WORKSPACE_DIR/build/"
LIB_DEST_DIR="$WORKSPACE_DIR/build/lib"

mkdir -p "$WORKSPACE_DIR"
mkdir -p "$LIB_DEST_DIR"

if [ ! -d "$TMP_DIR/sdl2_miyoo" ]; then
    echo "Cloning sdl2_miyoo repository..."
    git clone --depth=1 "$REPO_URL_SDL" -b "$BRANCH_SDL" "$TMP_DIR/sdl2_miyoo"
    cp -r "$TMP_DIR/sdl2_miyoo" "$WORKSPACE_DIR/"
fi

if [ ! -d "$TMP_DIR/neon-arm-library-miyoo" ]; then
    echo "Cloning neon-arm-library-miyoo repository..."
    git clone "$REPO_URL_NEON" "$TMP_DIR/neon-arm-library-miyoo"
    cp -r "$TMP_DIR/neon-arm-library-miyoo" "$WORKSPACE_DIR/"
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

cd "$WORKSPACE_DIR/neon-arm-library-miyoo"
export CROSS_COMPILE="arm-linux-gnueabihf-"
make
NEON_LIB_OUTPUT="$WORKSPACE_DIR/neon-arm-library-miyoo/lib"
NEON_INCLUDE_DIR="$WORKSPACE_DIR/neon-arm-library-miyoo/include"
if [ -d "$NEON_LIB_OUTPUT" ]; then
    cp -r "$NEON_LIB_OUTPUT"/* "$LIB_DEST_DIR"
    cp -r "$NEON_LIB_OUTPUT"/* "$SDL2_DIR"
    printf "${GREEN}NEON ARM library built and copied to: ${NC}$LIB_DEST_DIR\n"
    cp -r "$NEON_INCLUDE_DIR" "$INC_DEST_DIR/"
    printf "${GREEN}NEON ARM include directory copied to: ${NC}$INC_DEST_DIR\n"
else
    printf "${RED}Failed to build or locate NEON ARM library output.${NC}\n"
fi
unset CROSS_COMPILE

cd "$SDL2_DIR"
if [ -f "./run.sh" ]; then
    chmod +x ./run.sh
    ./run.sh config
    make -j$(( $(nproc) - 2 ))
    if [ -f "$LIB_SOURCE_PATH_SDL" ]; then
        cp "$LIB_SOURCE_PATH_SDL" "$LIB_DEST_DIR/libSDL2-2.0.so.0"
        printf "${GREEN}SDL2 library built and copied to: ${NC}$LIB_DEST_DIR\n"
    else
        printf "${RED}Failed to build SDL2 library.${NC}\n"
    fi
else
    printf "${RED}SDL2 run.sh script not found.${NC}\n"
fi

printf "${GREEN}=====================================\n"
printf "Setup Summary\n"
printf "=====================================${NC}\n"
printf "${GREEN}NEON ARM and SDL2 libraries, including NEON includes, should now be in: ${NC}$LIB_DEST_DIR\n"

exec /bin/bash
