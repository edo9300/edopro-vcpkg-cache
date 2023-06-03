#!/usr/bin/env bash

set -euo pipefail
RELEASE_URL=${1:-$RELEASE_URL}
ARCHIVE_NAME=${2:-$ARCHIVE_NAME}

if [[ $RUNNER_OS == "Windows" ]]; then
	bin_7z="$PROGRAMFILES/7-Zip/7z.exe"
else
	bin_7z="7z"
fi

dir=$PWD
cd $VCPKG_INSTALLATION_ROOT
"$bin_7z" x $dir/$ARCHIVE_NAME -aos
rm -f $dir/$ARCHIVE_NAME
