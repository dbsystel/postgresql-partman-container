#!/bin/bash

# Test build script for all PostgreSQL versions and partman combinations
# Extracts versions and checksums from GitHub workflow to stay DRY

set -e

# Extract data from workflow file
WORKFLOW_FILE=".github/workflows/build-and-publish.yml"

# Parse PostgreSQL versions
POSTGRES_VERSIONS=($(yq '.jobs.build.strategy.matrix.postgres_version[]' $WORKFLOW_FILE))

# Parse partman versions and checksums
PARTMAN_V4_VERSION=$(yq '.jobs.build.strategy.matrix.include[] | select(.major == 4) | .partman_version' $WORKFLOW_FILE)
PARTMAN_V4_CHECKSUM=$(yq '.jobs.build.strategy.matrix.include[] | select(.major == 4) | .partman_checksum' $WORKFLOW_FILE)
PARTMAN_V5_VERSION=$(yq '.jobs.build.strategy.matrix.include[] | select(.major == 5) | .partman_version' $WORKFLOW_FILE)
PARTMAN_V5_CHECKSUM=$(yq '.jobs.build.strategy.matrix.include[] | select(.major == 5) | .partman_checksum' $WORKFLOW_FILE)

for pg_version in "${POSTGRES_VERSIONS[@]}"; do
    echo "Building PostgreSQL $pg_version with partman v5..."
    docker build \
        --build-arg POSTGRESQL_VERSION=$pg_version \
        --build-arg PARTMAN_VERSION=$PARTMAN_V5_VERSION \
        --build-arg PARTMAN_CHECKSUM=$PARTMAN_V5_CHECKSUM \
        -t test-partman:$pg_version-5 .

    echo "Building PostgreSQL $pg_version with partman v4..."
    docker build \
        --build-arg POSTGRESQL_VERSION=$pg_version \
        --build-arg PARTMAN_VERSION=$PARTMAN_V4_VERSION \
        --build-arg PARTMAN_CHECKSUM=$PARTMAN_V4_CHECKSUM \
        -t test-partman:$pg_version-4 .
done

echo "All builds completed successfully!"
