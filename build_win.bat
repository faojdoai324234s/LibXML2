@echo off
setlocal EnableDelayedExpansion

set PROGFILES=%ProgramFiles%
if not "%ProgramFiles(x86)%" == "" set PROGFILES=%ProgramFiles(x86)%

REM Check if Visual Studio 2019 is installed
set MSVCDIR="%PROGFILES%\Microsoft Visual Studio\2019"
set VCVARSALLPATH="%PROGFILES%\Microsoft Visual Studio\2019\Enterprise\VC\Auxiliary\Build\vcvarsall.bat"
if exist %MSVCDIR% (
  if exist %VCVARSALLPATH% (
   	set COMPILER_VER="2019"
   	set VCVERSION = 16
   	echo Using Visual Studio 2019 Enterprise
	goto begin
  )
)

echo No compiler found : Microsoft Visual Studio 2019 Enterprise is not installed.
goto end

:begin

REM Download latest libXML2 and rename to libxml.zip
echo Downloading curl...
powershell -command "(new-object System.Net.WebClient).DownloadFile('https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.6.tar.xz','libxml2-2.13.6.tar.xz')"

REM Extract downloaded zip file to tmp_libcurl
REM "C:\Program Files\7-Zip\7z.exe" x libxml.zip -y -otmp_libxml
REM del libxml.zip

REM cd tmp_libxml

REM Build!
echo "Building libxml now!"

if [%1]==[-static] (
	set RTLIBCFG=static
	echo Using /MT instead of /MD
) 

echo "Path to vcvarsall.bat: %VCVARSALLPATH%"
call %VCVARSALLPATH% x64

cmake -E tar xf libxml2-2.13.6.tar.xz
cmake -D BUILD_SHARED_LIBS=ON CMAKE_BUILD_TYPE=Debug LIBXML2_WITH_ICONV=OFF LIBXML2_WITH_PYTHON=OFF
cmake -S libxml2-2.13.6 -B libxml2-2.13.6-build
cmake --build libxml2-2.13.6-build
cmake --install libxml2-2.13.6-build

cd D:\a\LibXML2\LibXML2\libxml2-2.13.6\build
dir /s

:end
echo Done.
exit /b
