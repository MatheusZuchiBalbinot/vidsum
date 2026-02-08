#!/usr/bin/env sh
set -e

echo "Waiting for database..."

until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME"
do
  sleep 1
done

echo "Generating app key if missing..."
php artisan key:generate --force || true

echo "Running migrations..."
php artisan migrate --force

echo "Starting Octane..."
exec php artisan octane:start \
  --server=frankenphp \
  --host=0.0.0.0 \
  --port=8000
