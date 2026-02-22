# GitHub Copilot Instructions

## Commit Messages

Always use [Conventional Commits](https://www.conventionalcommits.org/) format for commit messages:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc.)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files
- `revert`: Reverts a previous commit

### Examples

```
feat(homeassistant): add new automation for lights
fix(docker): correct base image version
docs: update README with setup instructions
ci: update GitHub Actions workflow
chore(deps): bump dependencies
```

## Docker Images

- Use **multi-stage builds**: a `build` stage for compilation/installation and a slim final stage to keep the image small.
- Base the build stage on `python:3.13-bookworm` and the final stage on `python:3.13-slim-bookworm`.
- Always **pin apt package versions** with exact Debian version strings (e.g. `build-essential=12.9`).
- Always **pin Python package versions** with exact version numbers (e.g. `homeassistant==2025.7.4`).
- Include both `org.label-schema` and `org.opencontainers.image` labels using `BUILD_DATE` and `VCS_REF` build args.
- Use `SHELL ["/bin/bash", "-o", "pipefail", "-c"]` and prefix `RUN` blocks with `set -eux`.
- Clean up apt caches at the end of every `RUN` block that calls `apt-get`:
  ```dockerfile
  && apt-get autoremove -y \
  && apt-get clean \
  && apt-get autoclean \
  && rm -rf /var/lib/apt/lists/*
  ```
- Pass `--no-cache-dir` to every `pip install` invocation.
- Expose ports explicitly (e.g. `EXPOSE 8123/tcp`).

## Linting

- Run linters via **pre-commit**: `make pre-commit` (runs `pre-commit run --all-files`).
- Install dependencies before linting: `make install`.
- The full test suite (lint + Docker build + Home Assistant config check) is run with: `make test`.
- All files must respect the **EditorConfig** settings:
  - LF line endings, UTF-8 encoding.
  - 2-space indentation (tabs only in `Makefile`).
  - A final newline and no trailing whitespace.
  - Maximum line length of 80 characters.
- Enabled pre-commit hooks: `check-added-large-files`, `check-case-conflict`,
  `check-executables-have-shebangs`, `check-merge-conflict`, `check-symlinks`,
  `detect-private-key`, `end-of-file-fixer`, `trailing-whitespace`.

## Docker Compose

- Always **pin image tags** with both a version tag and a SHA-256 digest:
  ```yaml
  image: prom/prometheus:v3.4.2@sha256:<digest>
  ```
- Set `restart: always` on every service.
- Assign each service to a **named network**; define networks with explicit CIDR
  subnets and gateways under the top-level `networks` key.
- Group related services on the same network (e.g. `monitoring`, `paperless`).
- Expose ports using the explicit `<host>:<container>/<protocol>` notation
  (e.g. `8123:8123/tcp`).
- Pass sensitive configuration through `env_file` (never hard-code secrets in
  the `environment` block).
- Mount host paths as volumes using the absolute path notation; mark read-only
  mounts with `:ro`.
