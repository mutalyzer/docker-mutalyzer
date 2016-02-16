#!/bin/bash
set -ex

if [[ $DATABASE_URI ]]; then
    echo "waiting for db..."
    sleep 4s

    echo "running db migrations..."
    mutalyzer-admin setup-database --alembic-config /data/mutalyzer/migrations/alembic.ini
else
    echo "DATABASE_URI is not set :: skipping db migrations"
fi

exec "$@"
