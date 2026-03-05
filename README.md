# vfox-jdtls

[vfox](https://vfox.dev) / [mise](https://mise.jdx.dev) plugin for installing [Eclipse JDT Language Server](https://github.com/eclipse-jdtls/eclipse.jdt.ls) (jdtls).

## Prerequisites

- **Java 21+** on PATH
- **Python 3** on PATH (used by the `jdtls` launcher script)

## Usage with mise

```bash
# Install a specific version
mise use vfox:tinnet/vfox-jdtls@1.57.0

# List available versions
mise ls-remote vfox:tinnet/vfox-jdtls

# Verify installation
mise which jdtls
jdtls --help
```

## Usage with vfox

```bash
# Add the plugin
vfox add --source https://github.com/tinnet/vfox-jdtls/releases/download/manifest/manifest.json jdtls

# Install a version
vfox install jdtls@1.57.0
vfox use jdtls@1.57.0
```

## Environment variables

| Variable      | Value                          |
|---------------|--------------------------------|
| `JDTLS_HOME`  | SDK installation directory     |
| `PATH`         | `$JDTLS_HOME/bin` is prepended |

## How it works

Eclipse publishes jdtls tarballs with build timestamps in the filename (e.g., `jdt-language-server-1.57.0-202602261110.tar.gz`). This plugin resolves the timestamp by scraping the [milestones directory](https://download.eclipse.org/jdtls/milestones/) at install time.

## Development

```bash
# Format Lua source code
mise run format
# or
mise run fmt
```

## Publishing

Push a tag matching `vX.Y.Z` to trigger CI that packages and publishes the plugin.
