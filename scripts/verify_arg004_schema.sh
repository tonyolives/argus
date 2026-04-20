#!/usr/bin/env bash

set -euo pipefail

POSTGRES_DB="${POSTGRES_DB:-argus}"
POSTGRES_USER="${POSTGRES_USER:-argus_user}"
COMPOSE_CMD="${COMPOSE_CMD:-docker compose}"

echo "Checking database tables..."
$COMPOSE_CMD exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\dt public.*'

echo
echo "Describing flights table..."
$COMPOSE_CMD exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\d flights'

echo
echo "Describing incidents table..."
$COMPOSE_CMD exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\d incidents'

echo
echo "Describing news_articles table..."
$COMPOSE_CMD exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c '\d news_articles'

echo
echo "Checking PostGIS extension version..."
$COMPOSE_CMD exec db psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c 'SELECT PostGIS_Version();'
