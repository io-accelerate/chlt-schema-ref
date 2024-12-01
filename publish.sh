#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Sync the version folder to S3
VERSION_FOLDER="${SCRIPT_DIR}/version"
S3_BUCKET="s3://get.accelerate.io/challenge-toolkit/schema/version"

aws s3 sync "$VERSION_FOLDER" "$S3_BUCKET"
