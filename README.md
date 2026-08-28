# docker-build-cpu

This repository standardizes Docker image builds through one fixed `buildx` script and a low-priority BuildKit builder.

## Index

- [Project policy](AGENTS.md)
- [Build script](scripts/docker-build.sh)
- [Architecture note](docs/architecture/buildkit-cpu-sharing.md)
- [Build flow diagram](docs/diagrams/docker-build-chain.svg)

## What it does

The build script creates or reuses a `buildx` builder named `elastic-builder` with `cpu-shares=256`, so BuildKit yields CPU under contention while still using idle capacity.

