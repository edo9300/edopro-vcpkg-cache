#!/usr/bin/env bash

set -euo pipefail
ARCHIVE_NAME=${1:-$ARCHIVE_NAME}

if [[ $RUNNER_OS == "Windows" ]]; then
	bin_7z="$PROGRAMFILES/7-Zip/7z.exe"
	FILES="installed scripts .vcpkg-root vcpkg.exe"
else
	bin_7z="7z"
	FILES="installed"
fi


cd $VCPKG_INSTALLATION_ROOT
"$bin_7z" a $ARCHIVE_NAME $FILES

echo "asset_path=$VCPKG_INSTALLATION_ROOT/$ARCHIVE_NAME" >> $GITHUB_OUTPUT
