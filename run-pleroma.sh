#!/usr/bin/env bash

set -euo pipefail

while ! pg_isready -U "${POSTGRES_USER:-pleroma}" -d "postgres://${POSTGRES_HOST:-postgres}:5432/${POSTGRES_DB:-pleroma}" -t 1; do
  echo "Waiting for ${POSTGRES_HOST-postgres} to come up..." >&2
  sleep 1s
done

if [ ! -e "$PLEROMA_CONFIG_PATH" ] ; then
  generate-pleroma-config.sh
fi

if [ "${USE_RUM:-n}" = "y" ] ; then
  pleroma_ctl migrate
fi

pleroma_ctl migrate --migrations-path priv/repo/optional_migrations/rum_indexing/

exec pleroma start
