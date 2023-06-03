#!/usr/bin/env bash

set -euo pipefail
ARCHIVE_NAME=${1:-$ARCHIVE_NAME}

echo $ARCHIVE_NAME

if [[ "$ARCHIVE_NAME" == "installed_x86-windows-static.zip" || "$ARCHIVE_NAME" == "installed_x86-windows-static-vs2017.zip" ]]; then
	toolset="v141"
elif [[ "$ARCHIVE_NAME" == "installed_x86-windows-static-vs2019.zip" ]]; then
	toolset="v142"
elif [[ "$ARCHIVE_NAME" == "installed_x86-windows-static-vs2022.zip" ]]; then
	toolset="v143"
elif [[ "$ARCHIVE_NAME" == "installed_x86-windows-static-vs2015.zip" ]]; then
	toolset="v140"
fi

if [[ $ARCHIVE_NAME == "installed_x86-windows-static.zip" ]]; then
	# vcpkg doesn't like when we pass an _xp toolset to it
	# so make the v141_Xp toolset the v141 and pass it to the triplet
	pushd .
	cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\Enterprise\MSBuild\Microsoft\VC\v150\Platforms\Win32\PlatformToolsets"
	rm -r v141 || true
	mv v141_xp v141
	popd
	rm ./ports/libssh2/portfile.cmake
	mv ./ports/libssh2/portfile-force-vs2019-generator-2017-toolset.cmake ./ports/libssh2/portfile.cmake
	rm ./ports/openal-soft/portfile.cmake
	mv ./ports/openal-soft/portfile-force-vs2019-generator-2017-toolset.cmake ./ports/openal-soft/portfile.cmake
elif [[ $ARCHIVE_NAME == "installed_x86-windows-static-vs2017.zip" ]]; then
	rm ./ports/libssh2/portfile.cmake
	mv ./ports/libssh2/portfile-force-vs2022-generator.cmake ./ports/libssh2/portfile.cmake
	rm ./ports/openal-soft/portfile.cmake
	mv ./ports/openal-soft/portfile-force-vs2022-generator.cmake ./ports/openal-soft/portfile.cmake
elif [[ $ARCHIVE_NAME == "installed_x86-windows-static-vs2015.zip" ]]; then
	rm ./ports/libssh2/portfile.cmake
	mv ./ports/libssh2/portfile-force-vs2019-generator.cmake ./ports/libssh2/portfile.cmake
	rm -r ./ports/openal-soft
	mv ./ports/openal-soft-vs2015 ./ports/openal-soft
fi


cd "$VCPKG_INSTALLATION_ROOT"
echo -e "\nset(VCPKG_PLATFORM_TOOLSET $toolset)" >> triplets/community/x86-windows-static.cmake