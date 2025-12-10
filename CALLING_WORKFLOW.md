# Calling the Homebrew Formula Bump Workflow

This guide explains how to call the `bump-version.yml` workflow from the `teamlumos/lumos-cli` repository to automatically update Homebrew formulas after a release.

## Overview

The `bump-version.yml` workflow in the `teamlumos/homebrew-tap` repository:
- ✅ Accepts a version string input
- ✅ Can be called from another workflow via `workflow_call`
- ✅ Updates formulas to support multi-platform (macOS Intel/ARM, Linux AMD64/ARM64)
- ✅ Downloads releases from `teamlumos/lumos-cli`
- ✅ Automatically calculates checksums for all platform binaries
- ✅ Commits and pushes the updated formula

## Prerequisites

### 1. Release Asset Naming Convention

Your release workflow in `teamlumos/lumos-cli` must create assets with these exact names:

- `lumos-darwin-amd64.tar.gz` - macOS Intel
- `lumos-darwin-arm64.tar.gz` - macOS ARM (Apple Silicon)
- `lumos-linux-amd64.tar.gz` - Linux AMD64
- `lumos-linux-arm64.tar.gz` - Linux ARM64

Each tarball should contain a single `lumos` binary at the root level.

### 2. Required Secret

Add this secret to the `teamlumos/lumos-cli` repository:

- **`HOMEBREW_TAP_TOKEN`**: A GitHub Personal Access Token (classic) with `repo` scope
  - Must have write access to `teamlumos/homebrew-tap`
  - [Create a PAT here](https://github.com/settings/tokens)

## Integration Methods

### Method 1: Using `workflow_call` (Recommended)

Add this job to your `release.yml` workflow in `teamlumos/lumos-cli`:

```yaml
jobs:
  # ... your existing build and release jobs ...

  update-homebrew:
    name: Update Homebrew Formula
    needs: [build-and-release]  # Wait for release assets to be uploaded
    uses: teamlumos/homebrew-tap/.github/workflows/bump-version.yml@main
    with:
      version: ${{ github.event.release.tag_name }}
      prerelease: ${{ github.event.release.prerelease }}
    secrets:
      HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

### Method 2: Using `repository_dispatch`

If you need more control, trigger via repository dispatch:

```yaml
- name: Trigger Homebrew Formula Update
  run: |
    VERSION="${{ github.event.release.tag_name }}"
    VERSION="${VERSION#v}"  # Remove 'v' prefix if present
    
    curl -X POST \
      -H "Authorization: token ${{ secrets.HOMEBREW_TAP_TOKEN }}" \
      -H "Accept: application/vnd.github.v3+json" \
      https://api.github.com/repos/teamlumos/homebrew-tap/dispatches \
      -d "{\"event_type\":\"version-bump\",\"client_payload\":{\"version\":\"${VERSION}\",\"prerelease\":${{ github.event.release.prerelease }}}}"
```

Then add this trigger to `bump-version.yml`:

```yaml
on:
  workflow_dispatch:
    # ... existing inputs ...
  repository_dispatch:
    types: [version-bump]
```

## Complete Example

Here's a complete example `release.yml` for `teamlumos/lumos-cli`:

```yaml
name: Release

on:
  release:
    types: [published]

jobs:
  build:
    name: Build Multi-Platform Binaries
    runs-on: ubuntu-latest
    strategy:
      matrix:
        include:
          - goos: darwin
            goarch: amd64
            platform: darwin-amd64
          - goos: darwin
            goarch: arm64
            platform: darwin-arm64
          - goos: linux
            goarch: amd64
            platform: linux-amd64
          - goos: linux
            goarch: arm64
            platform: linux-arm64
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version: '1.21'
      
      - name: Build binary
        env:
          GOOS: ${{ matrix.goos }}
          GOARCH: ${{ matrix.goarch }}
        run: |
          go build -o lumos -ldflags="-s -w" .
          tar -czf lumos-${{ matrix.platform }}.tar.gz lumos
      
      - name: Upload to release
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ github.event.release.upload_url }}
          asset_path: ./lumos-${{ matrix.platform }}.tar.gz
          asset_name: lumos-${{ matrix.platform }}.tar.gz
          asset_content_type: application/gzip

  update-homebrew:
    name: Update Homebrew Formula
    needs: build
    uses: teamlumos/homebrew-tap/.github/workflows/bump-version.yml@main
    with:
      version: ${{ github.event.release.tag_name }}
      prerelease: ${{ github.event.release.prerelease }}
    secrets:
      HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

## Version Format

The workflow handles versions flexibly:

- ✅ `2.1.3` - Standard version
- ✅ `v2.1.3` - With 'v' prefix (automatically stripped)
- ✅ `2.1.3-beta` - Prerelease with suffix

For prereleases, the workflow:
- Appends `-prerelease` to create the Git tag (e.g., `2.1.3-prerelease`)
- Updates `Formula/lumos-prerelease.rb` instead of `Formula/lumos.rb`

## Manual Trigger

You can also manually run the workflow:

1. Go to [Actions → Bump Homebrew Formula Version](https://github.com/teamlumos/homebrew-tap/actions/workflows/bump-version.yml)
2. Click **"Run workflow"**
3. Enter the version (e.g., `2.1.3`)
4. Check **"Is this a prerelease?"** if applicable
5. Click **"Run workflow"**

## Workflow Steps

The `bump-version.yml` workflow:

1. **Downloads release assets** from `teamlumos/lumos-cli` using the GitHub CLI
2. **Calculates SHA256 checksums** for each platform binary
3. **Updates the formula** with:
   - New version number
   - Updated download URLs pointing to `teamlumos/lumos-cli`
   - Platform-specific checksums
   - Multi-platform support (macOS Intel/ARM, Linux AMD64/ARM64)
4. **Commits and pushes** the changes to `teamlumos/homebrew-tap`
5. **Generates a summary** with all checksums for verification

## Troubleshooting

### Missing Assets

If assets are missing for certain platforms, the workflow will:
- Log a warning
- Continue with available platforms
- The formula will only support platforms with available binaries

### Authentication Issues

If you see `403 Forbidden` errors:
- Verify `HOMEBREW_TAP_TOKEN` is set correctly
- Check the token has `repo` scope
- Ensure the token hasn't expired

### Checksum Mismatches

If users report checksum errors:
- Ensure binaries are built correctly
- Verify asset names match exactly
- Check that assets aren't modified after upload

## Testing

Before releasing, test the formula locally:

```bash
# Test the formula syntax
brew audit --strict --online ./Formula/lumos.rb

# Install from the formula
brew install --build-from-source ./Formula/lumos.rb

# Verify installation
lumos --version

# Run formula tests
brew test lumos
```

## Support

For issues with the workflow, please open an issue in the [homebrew-tap repository](https://github.com/teamlumos/homebrew-tap/issues).
