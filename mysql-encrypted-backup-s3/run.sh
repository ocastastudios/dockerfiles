#! /bin/sh

set -e

if [ "${SCHEDULE}" = "**None**" ]; then
  sh backup.sh
else
  exec go-cron -s "$SCHEDULE" -- /bin/sh backup.sh
fi
