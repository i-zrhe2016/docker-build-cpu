---
name: docker-build-cpu
description: Apply the repository workflow for CPU-aware Docker builds, architecture, documentation, validation, Git, and completion notifications when working in /root/docker-build-cpu.
---

# docker-build-cpu Repository Workflow

Use this skill for changes, reviews, troubleshooting, or documentation work in
`/root/docker-build-cpu`. Treat the repository's `AGENTS.md` as the source of
project-specific policy when it is present.

## Working principles

- Prefer the smallest correct, maintainable solution. Do not add speculative
  features, unrelated refactors, formatting churn, or dependency upgrades.
- For non-trivial work, understand module boundaries, data flow, and call
  relationships before choosing a design. Keep closely related behavior
  together; split services only when a real boundary justifies it.
- Reuse existing scripts, components, and framework capabilities before
  introducing new ones.

## Discovery and implementation

1. Search first with `rg` or `rg --files`; inspect only the relevant files and
   lines. Cap potentially large command output, for example:
   `COMMAND 2>&1 | head -c 4000`.
2. For non-trivial changes, write down the smallest design that fits the
   existing architecture. If architecture, data flow, call chain, or
   deployment relationships materially change, update the relevant diagram
   with `plantuml-skill`.
3. Implement one clearly scoped function at a time, then run validation
   proportional to the change.

## Documentation

- Keep detailed documentation under `docs/`, organized by responsibility
  (`architecture/`, `services/`, `api/`, `database/`, `deployment/`,
  `testing/`, `troubleshooting/`, and `diagrams/` as applicable).
- Keep the root `README.md` focused on project introduction and documentation
  index. Each detailed document should cover one module or topic.
- Record important architecture, interfaces, data structures, deployment
  behavior, and technical decisions. Update related docs when code changes;
  update the README index when the document structure changes.

## Docker builds

Always build images through:

```bash
./scripts/docker-build.sh <image:tag> [context]
```

Do not call `docker build` or `docker buildx build` directly unless the user
explicitly requests it. The script creates or reuses the `elastic-builder`
Buildx builder with the default `cpu-shares=256`; Linux cgroup scheduling
determines the actual CPU time dynamically under contention. Use only the
script's supported configuration when a non-default builder or share value is
needed.

## Validation and Git

- Validate in increasing scope: local checks, focused tests, module tests,
  integration tests, then the full suite only when the change warrants it.
- Before committing, inspect `git status` and `git diff --stat`. Keep each
  commit to one feature or explicit purpose, use commit identity
  `i-zrhe2016`, and never commit or push `AGENTS.md`, `CLAUDE.md`, credentials,
  tokens, API keys, private keys, or `.env` files.
- Use subagents only when clearly independent work can be parallelized; do not
  use them for simple tasks.

## Completion notification

After implementation and validation, immediately before the final response,
send exactly one Bark notification:

```bash
python3 /root/.codex/skills/bark-finish-notify/scripts/send_bark.py \
  --summary "<short, concrete result>" \
  --project "docker-build-cpu"
```

The summary must reflect the actual outcome, including partial or blocked
work. A Bark delivery failure does not block the final response, but must be
reported there.
