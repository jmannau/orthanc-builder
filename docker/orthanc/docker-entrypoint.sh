#!/usr/bin/env bash
set -o errexit
base=/usr/lib/orthanc

# call setup.sh on each setup procedure script found in $base/setup.d (one for each plugin).
find "$base/setup.d" -type f -exec "$base/setup.sh" "{}" ";"

echo "Startup command: Orthanc $@" >&2
exec Orthanc "$@"
