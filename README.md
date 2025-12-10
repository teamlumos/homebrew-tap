# Lumos Homebrew Tap

Official Homebrew tap for [Lumos CLI](https://github.com/teamlumos/lumos-cli).

## Installation

### Stable Release

```bash
brew tap teamlumos/tap
brew install lumos
```

### Prerelease

```bash
brew tap teamlumos/tap
brew install lumos-prerelease
```

## Usage

After installation, verify the CLI is working:

```bash
lumos --version
```

## For Maintainers

### Automated Version Bumping

This repository includes a reusable workflow (`bump-version.yml`) that automatically updates Homebrew formulas when called from the `teamlumos/lumos-cli` repository.

#### Calling from Another Workflow

To trigger the version bump from your release workflow in `teamlumos/lumos-cli`, add this step:

```yaml
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      # ... your release steps ...
      
      - name: Update Homebrew Formula
        uses: teamlumos/homebrew-tap/.github/workflows/bump-version.yml@main
        with:
          version: ${{ github.event.release.tag_name }}  # e.g., "2.1.3"
          prerelease: ${{ github.event.release.prerelease }}  # true/false
        secrets:
          HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

#### Complete Example

Here's a complete example of how to integrate this into your `release.yml` workflow:

```yaml
name: Release

on:
  release:
    types: [published]

jobs:
  build:
    name: Build Release Binaries
    runs-on: ubuntu-latest
    strategy:
      matrix:
        include:
          - os: darwin
            arch: amd64
          - os: darwin
            arch: arm64
          - os: linux
            arch: amd64
          - os: linux
            arch: arm64
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Build binary
        run: |
          # Your build commands here
          # Output should be: lumos-${{ matrix.os }}-${{ matrix.arch }}.tar.gz
      
      - name: Upload to release
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ github.event.release.upload_url }}
          asset_path: ./lumos-${{ matrix.os }}-${{ matrix.arch }}.tar.gz
          asset_name: lumos-${{ matrix.os }}-${{ matrix.arch }}.tar.gz
          asset_content_type: application/gzip

  update-homebrew:
    name: Update Homebrew Formula
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Extract version from tag
        id: version
        run: |
          # Remove 'v' prefix if present
          VERSION="${{ github.event.release.tag_name }}"
          VERSION="${VERSION#v}"
          echo "version=$VERSION" >> $GITHUB_OUTPUT
      
      - name: Trigger Homebrew Formula Update
        uses: convictional/trigger-workflow-and-wait@v1.6.1
        with:
          owner: teamlumos
          repo: homebrew-tap
          github_token: ${{ secrets.HOMEBREW_TAP_TOKEN }}
          workflow_file_name: bump-version.yml
          ref: main
          wait_interval: 10
          client_payload: |
            {
              "version": "${{ steps.version.outputs.version }}",
              "prerelease": ${{ github.event.release.prerelease }}
            }
```

#### Manual Trigger

You can also manually trigger the version bump from the GitHub Actions UI:

1. Go to the [Actions tab](../../actions/workflows/bump-version.yml)
2. Click "Run workflow"
3. Enter the version number (e.g., `2.1.3`)
4. Check "Is this a prerelease?" if applicable
5. Click "Run workflow"

### Required Secrets

The calling repository (`teamlumos/lumos-cli`) needs the following secret:

- `HOMEBREW_TAP_TOKEN`: A GitHub Personal Access Token (PAT) with `repo` scope for the `teamlumos/homebrew-tap` repository

### Release Asset Naming Convention

The workflow expects release assets to follow this naming convention:

- `lumos-darwin-amd64.tar.gz` - macOS Intel
- `lumos-darwin-arm64.tar.gz` - macOS ARM (Apple Silicon)
- `lumos-linux-amd64.tar.gz` - Linux AMD64
- `lumos-linux-arm64.tar.gz` - Linux ARM64

Each tarball should contain a single `lumos` binary at the root level.

### Multi-Platform Support

The Homebrew formulas now support multiple platforms:

- **macOS**: Intel (x86_64) and Apple Silicon (ARM64)
- **Linux**: AMD64 and ARM64

The formula automatically detects the platform and downloads the appropriate binary.

### Formula Files

- `Formula/lumos.rb` - Stable releases
- `Formula/lumos-prerelease.rb` - Prerelease versions

## Development

To test the formula locally before publishing:

```bash
# Install from local tap
brew install --build-from-source ./Formula/lumos.rb

# Audit the formula
brew audit --strict --online lumos

# Test the formula
brew test lumos
```

## Contributing

Please submit issues and pull requests to improve the formulas or automation.

## License

MIT
