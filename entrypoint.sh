#!/bin/sh
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

if [ "$RAILS_ENV" = "development" ]; then
  bundle check || bundle install
fi

# Now running any arbitrary commands that might have been passed in
exec "$@"
