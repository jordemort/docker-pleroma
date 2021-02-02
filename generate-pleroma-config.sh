#!/usr/bin/env bash

set -euo pipefail

if [ -z "${DOMAIN:-}" ] ; then
  echo "ERROR: Please set DOMAIN before generating config" >&2
  exit 1
fi

if [ -z "${ADMIN_EMAIL:-}" ] ; then
  echo "ERROR: Please set ADMIN_EMAIL before generating config" >&2
  exit 1
fi

if [ -z "${POSTGRES_PASSWORD:-}" ] ; then
  echo "ERROR: Please set POSTGRES_PASSWORD before generating config" >&2
  exit 1
fi

pleroma_ctl instance gen --output "$PLEROMA_CONFIG_PATH" \
  --output-psql /tmp/setup_db.sql \
  --domain "$DOMAIN" \
  --instance-name "${INSTANCE_NAME:-$DOMAIN}" \
  --admin-email "$ADMIN_EMAIL" \
  --notify-email "${NOTIFY_EMAIL:-$ADMIN_EMAIL}" \
  --dbhost "${POSTGRES_HOST:-postgres}" \
  --dbname "${POSTGRES_DB:-pleroma}" \
  --dbuser "${POSTGRES_USER:-pleroma}" \
  --dbpass "$POSTGRES_PASSWORD" \
  --rum "${USE_RUM:-n}" \
  --indexable "${INDEXABLE:-y}" \
  --db-configurable "${DB_CONFIGURABLE:-y}" \
  --uploads-dir "${UPLOADS_DIR:-/var/lib/pleroma/uploads}" \
  --static-dir "${STATIC_DIR:-/var/lib/pleroma/static}" \
  --listen-ip "${LISTEN_IP:-0.0.0.0}" \
  --listen-port "${LISTEN_PORT:-4000}" \
  --strip-uploads "${STRIP_UPLOADS:-y}" \
  --anonymize-uploads "${ANONYMIZE_UPLOADS:-y}" \
  --dedupe-uploads "${DEDUPE_UPLOADS:-y}"
