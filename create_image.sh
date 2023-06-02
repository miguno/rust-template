#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
# `-u`: Errors if a variable is referenced before being set
# `-o pipefail`: Prevent errors in a pipeline (`|`) from being masked
set -uo pipefail

# Import environment variables from .env
set -o allexport && source .env && set +o allexport

echo "Building image '$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG'..."
# Use BuildKit, i.e. `buildx build` instead of just `build`
# https://docs.docker.com/build/
#
DOCKER_OPTIONS=""
if [[ "$SHOW_PROGRESS" -ne 0 ]]; then
    # `--progress=plain` prints the full docker output, very useful when you
    # are troubleshooting the build setup of your image
    DOCKER_OPTIONS="$DOCKER_OPTIONS --progress=plain"
fi
docker buildx build $DOCKER_OPTIONS -t "$DOCKER_IMAGE_NAME":"$DOCKER_IMAGE_TAG" .
