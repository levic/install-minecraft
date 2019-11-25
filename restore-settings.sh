#!/bin/bash -e
set -o pipefail

if [[ $1 == "" ]] || [[ $1 == "--help" ]] ; then
	echo "Usage: $0 bedrock_server_dir"
	echo
fi

cd -- "$1"

[[ -e server.properties ]] || { echo 'server.properiees missing' ; exit 1 ; }

crudini --set server.properties '' difficulty normal
crudini --set server.properties '' level-name "The Cameron World II (577830886)"
crudini --set server.properties '' level-seed 577830886
crudini --set server.properties '' online-mode false

[[ -e permissions.json ]] || { echo 'permissions.json missing' ; exit 1 ; }
echo '[
   {
      "permission" : "operator",
      "xuid" : "2535461817696832"
   }
]' > permissions.json
