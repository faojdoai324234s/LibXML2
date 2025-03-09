@echo off
setlocal EnableDelayedExpansion

mkdir upload
mkdir upload\include\libxml2
mkdir upload\Debug
mkdir upload\Release

REM Download latest libXML2
git clone https://github.com/GNOME/libxml2

REM Build Debug configuration
cmake -S GNOME\libxml2 -B build -D LIBXML2_WITH_ICONV=OFF -D LIBXML2_WITH_PYTHON=OFF
cmake --build build --config Debug
cmake --install build

REM Copy over the built files
copy /y /v build\Debug\*.dll upload\Debug
copy /y /v build\Debug\libxml2.lib upload\Debug\libxml2_debug.lib
copy /y /v build\Debug\*.pdb upload\Debug

REM Clean up before we run CMake again
rmdir /s /q build

REM Build Release configuration
cmake -S GNOME\libxml2 -B build -D LIBXML2_WITH_ICONV=OFF -D LIBXML2_WITH_PYTHON=OFF
cmake --build build --config Release
cmake --install build

REM Copy over the built files
copy /y /v build\Release\*.dll upload\Release
copy /y /v build\Release\*.lib upload\Release

REM Copy over the headers
copy /y /v GNOME\libxml2\include upload\include\libxml2

exit /b
