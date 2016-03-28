#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

readonly DB_NAME=${DB_NAME:-noise}
readonly DB_USER=${DB_USER:-noise}
readonly DB_PASSWORD=${DB_PASSWORD:-noise}
readonly DB_HOST=postgres

function exec_psql_file() {
    local file_name="$1"
    PG_PASSWORD="$DB_PASSWORD" psql \
        -v ON_ERROR_STOP=1 \
        --host="$DB_HOST" \
        --port=5432 \
        --dbname="$DB_NAME" \
        --username="$DB_USER" \
        -f "$file_name"
}

function main() {
    exec_psql_file "functions.sql"
    exec_psql_file "schema.sql"
    exec_psql_file "views.sql"
}

main
