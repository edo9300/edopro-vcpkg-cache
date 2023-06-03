#!/usr/bin/env bash

set -euo pipefail
RELEASE_URL=${1:-$RELEASE_URL}
ARCHIVE_NAME=${2:-$ARCHIVE_NAME}
GITHUB_TOKEN=${3:-$GITHUB_TOKEN}

if [[ "$REF_TYPE" == "tag" ]]; then
	curl -H "Authorization: token $GITHUB_TOKEN" -o tmp.json $RELEASE_URL
	echo "$(node -e "console.log(JSON.stringify(JSON.parse(require('fs').readFileSync('./tmp.json'))[1]))")" >> previous.json
	rm -f tmp.json
else
	curl -H "Authorization: token $GITHUB_TOKEN" -o previous.json $RELEASE_URL/latest
fi
curl -O -J -L -H "Authorization: token $GITHUB_TOKEN" -H \
"Accept: application/octet-stream" \
"$(node -e "JSON.parse(require('fs').\
readFileSync('./previous.json'))['assets'].\
forEach(function(obj){if(obj['name']=='$ARCHIVE_NAME'){ console.log(obj['url']) }})")"
