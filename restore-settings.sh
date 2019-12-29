#!/bin/bash -e
set -o pipefail

source "$( dirname "${BASH_SOURCE[0]}")/settings.inc"

if [[ $1 == "" ]] || [[ $1 == "--help" ]] ; then
	echo "Usage: $0 bedrock_server_dir"
	echo
fi

cd -- "$1"

[[ -e server.properties ]] || { echo 'server.properties missing' ; exit 1 ; }

crudini --set server.properties '' difficulty normal
crudini --set server.properties '' level-name "$level_name"
crudini --set server.properties '' level-seed "$level_seed"
crudini --set server.properties '' online-mode false

[[ -e permissions.json ]] || { echo 'permissions.json missing' ; exit 1 ; }
echo "[
   {
      \"permission\" : \"operator\",
      \"xuid\" : \"$operator_xuid\"
   }
]" > permissions.json
