# Quick Reference: Homebrew Formula Bump

## TL;DR

Add this to your `release.yml` in `teamlumos/lumos-cli`:

```yaml
jobs:
  update-homebrew:
    name: Update Homebrew Formula
    needs: [build]  # Wait for release assets
    uses: teamlumos/homebrew-tap/.github/workflows/bump-version.yml@main
    with:
      version: ${{ github.event.release.tag_name }}
      prerelease: ${{ github.event.release.prerelease }}
    secrets:
      HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

## Required Release Assets

Your release must include these files:

```
lumos-darwin-amd64.tar.gz   # macOS Intel
lumos-darwin-arm64.tar.gz   # macOS ARM
lumos-linux-amd64.tar.gz    # Linux AMD64
lumos-linux-arm64.tar.gz    # Linux ARM64
```

Each tarball contains a single `lumos` binary.

## Required Secret

Set in `teamlumos/lumos-cli` repository settings:

- **Name:** `HOMEBREW_TAP_TOKEN`
- **Value:** GitHub PAT (classic) with `repo` scope
- **Access:** Write access to `teamlumos/homebrew-tap`

## What It Does

1. Downloads your release assets from `teamlumos/lumos-cli`
2. Calculates SHA256 checksums for all platforms
3. Updates the Homebrew formula with multi-platform support
4. Commits and pushes to `teamlumos/homebrew-tap`

## Prerelease Handling

- **Regular release:** Updates `Formula/lumos.rb`, tag is `{version}`
- **Prerelease:** Updates `Formula/lumos-prerelease.rb`, tag is `{version}-prerelease`

## Manual Trigger

Go to: https://github.com/teamlumos/homebrew-tap/actions/workflows/bump-version.yml

Click "Run workflow" and enter version.

---

📚 **Full documentation:** See [CALLING_WORKFLOW.md](./CALLING_WORKFLOW.md)
