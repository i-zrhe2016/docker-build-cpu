#!/usr/bin/env bash
set -euo pipefail

BUILDER="${BUILDER_NAME:-elastic-builder}"
CPU_SHARES="${CPU_SHARES:-256}"
IMAGE="${1:-app:latest}"
CONTEXT="${2:-.}"

if ! docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
  docker buildx create \
    --name "$BUILDER" \
    --driver docker-container \
    --driver-opt "cpu-shares=${CPU_SHARES}"
fi

docker buildx use "$BUILDER"
docker buildx inspect --bootstrap >/dev/null

docker buildx build \
  --load \
  -t "$IMAGE" \
  "$CONTEXT"

