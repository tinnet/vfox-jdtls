# CLAUDE.md — Agent Steering

## Project Overview

vfox plugin for installing [Eclipse JDT Language Server (jdtls)](https://github.com/eclipse-jdtls/eclipse.jdt.ls). Users run `vfox install jdtls@<version>` and the plugin handles downloading, checksum verification, and environment setup.

## Tech Stack

- **Lua** — vfox plugin hook API
- **hk** + **betterleaks** — pre-commit secret scanning
- **pkl** — hk configuration (`hk.pkl`)
- **mise** — tool management (`mise.toml` installs hk, pkl, betterleaks)

## File Structure

```
hooks/
├── available.lua       # Scrapes Eclipse directory listing for versions
├── pre_install.lua     # Resolves timestamped tarball URL + SHA256
├── post_install.lua    # Removes Windows-only config dirs after install
└── env_keys.lua        # Sets JDTLS_HOME and PATH
metadata.lua            # Plugin name, version, manifest URL
hk.pkl                  # Pre-commit hook config (betterleaks)
mise.toml               # Dev tool versions + tasks
```

## Key Gotcha: Eclipse Directory Listing

The Eclipse download server renders HTML directory listings with **single-quoted absolute hrefs** like `'/jdtls/milestones/1.57.0'`. The regex in `available.lua` matches the **path** (`/jdtls/milestones/(%d+%.%d+%.%d+)`), not quoted href attribute values. Keep this in mind when modifying version scraping.

## Versioning

- **Plugin version** (`metadata.lua`): SemVer tags `vX.Y.Z`, independent of jdtls
- **jdtls version**: user-requested, scraped live from `download.eclipse.org`
- `available.lua` deduplicates and sorts versions descending (newest first)

## Commands

```bash
hk check                # Run pre-commit linters manually
mise run scan-secrets    # Deep scan full git history for secrets
```

### Local testing

```bash
vfox add --source /path/to/vfox-jdtls jdtls
vfox install jdtls@latest
```

## CI

- `.github/workflows/publish.yaml` triggers on `v*` tags (or merged PRs titled "Release vX.Y.Z")
- Uses `version-fox/plugin-manifest-action` to publish manifest + GitHub Release
- Tag version has `v` prefix stripped before publishing

## Conventions

- Conventional commits: `feat:`, `fix:`, `build:`, `ci:`, `docs:`, `refactor:`
