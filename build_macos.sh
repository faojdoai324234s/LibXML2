#!/bin/bash

# Prepare the build with creating the file structure
mkdir upload
mkdir upload/include
mkdir upload/include/libxml2
mkdir upload/Debug
mkdir upload/Release

git clone https://github.com/GNOME/libxml2

# Build Debug configuration
cmake -S libxml2 -B build -D LIBXML2_WITH_ICONV=OFF -D LIBXML2_WITH_PYTHON=OFF -D CMAKE_BUILD_TYPE=Debug
cmake --build build --config Debug
cmake --install build

# Copy over the built files
cp build/libxml2.dylib upload/Debug/libxml2d.dylib

# Clean up before we run CMake again
rm -rf build

# Build Release configuration
cmake -S libxml2 -B build -D LIBXML2_WITH_ICONV=OFF -D LIBXML2_WITH_PYTHON=OFF -D CMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build

# Copy over the built files
cp build/libxml2.dylib upload/Release

# Copy over the headers
cp -r libxml2/include/. upload/include/libxml2
