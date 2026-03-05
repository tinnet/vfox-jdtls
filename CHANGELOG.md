# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-03-05

### Fixed

- Numeric semver comparison for version sorting — `mise use` without a version now correctly selects the highest version (e.g. `1.57.0` over `1.9.0`)
- Eclipse directory listing scraping now uses path-based href pattern (`/jdtls/milestones/X.Y.Z`) for reliable HTML parsing

### Build

- Added `hk` + `betterleaks` pre-commit secret scanning
- Added StyLua Lua formatter with pre-commit hook
- Added `mise run scan-secrets` task for full git history secret scans

## [0.1.0] - 2026-03-05

### Added

- Initial vfox plugin for Eclipse JDT Language Server (jdtls)
- `available.lua` — scrapes `download.eclipse.org` for available jdtls versions
- `pre_install.lua` — resolves timestamped tarball URL and SHA256 checksum
- `post_install.lua` — removes Windows-only config directories after install
- `env_keys.lua` — sets `JDTLS_HOME` and `PATH` environment variables
