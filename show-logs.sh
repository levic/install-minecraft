#!/bin/bash -e
set -o pipefail

journalctl  --user --unit=minecraft@default --line=40 "$@"
