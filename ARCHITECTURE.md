# Workflow Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                     teamlumos/lumos-cli                             │
│                                                                     │
│  1. Developer creates release (v2.1.3)                             │
│  2. CI builds binaries for all platforms                           │
│  3. CI uploads assets to GitHub Release:                           │
│     • lumos-darwin-amd64.tar.gz                                    │
│     • lumos-darwin-arm64.tar.gz                                    │
│     • lumos-linux-amd64.tar.gz                                     │
│     • lumos-linux-arm64.tar.gz                                     │
│                                                                     │
│  4. CI triggers homebrew-tap workflow ───────────────┐             │
└─────────────────────────────────────────────────────┼─────────────┘
                                                       │
                                                       │ workflow_call
                                                       │ (version: 2.1.3)
                                                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   teamlumos/homebrew-tap                            │
│                                                                     │
│  .github/workflows/bump-version.yml                                │
│  ┌───────────────────────────────────────────────────────────┐    │
│  │ 1. Download assets from lumos-cli                         │    │
│  │    ▼ lumos-darwin-amd64.tar.gz                            │    │
│  │    ▼ lumos-darwin-arm64.tar.gz                            │    │
│  │    ▼ lumos-linux-amd64.tar.gz                             │    │
│  │    ▼ lumos-linux-arm64.tar.gz                             │    │
│  │                                                            │    │
│  │ 2. Calculate SHA256 checksums                             │    │
│  │    darwin-amd64:  518c78d52e30408845ecc...                │    │
│  │    darwin-arm64:  a1b2c3d4e5f6...                         │    │
│  │    linux-amd64:   f1e2d3c4b5a6...                         │    │
│  │    linux-arm64:   9a8b7c6d5e4f...                         │    │
│  │                                                            │    │
│  │ 3. Update Formula/lumos.rb                                │    │
│  │    • Set version to 2.1.3                                 │    │
│  │    • Update URLs to lumos-cli release                     │    │
│  │    • Set platform-specific checksums                      │    │
│  │                                                            │    │
│  │ 4. Commit and push                                        │    │
│  │    "chore: bump lumos to 2.1.3"                           │    │
│  └───────────────────────────────────────────────────────────┘    │
│                                                                     │
│  Formula/lumos.rb                                                  │
│  ┌───────────────────────────────────────────────────────────┐    │
│  │ class Lumos < Formula                                     │    │
│  │   version "2.1.3"                                         │    │
│  │                                                            │    │
│  │   on_macos do                                             │    │
│  │     if Hardware::CPU.intel?                               │    │
│  │       url ".../lumos-darwin-amd64.tar.gz"                 │    │
│  │       sha256 "518c78d52e30..."                            │    │
│  │     elsif Hardware::CPU.arm?                              │    │
│  │       url ".../lumos-darwin-arm64.tar.gz"                 │    │
│  │       sha256 "a1b2c3d4e5f6..."                            │    │
│  │   end                                                      │    │
│  │                                                            │    │
│  │   on_linux do                                             │    │
│  │     if Hardware::CPU.intel?                               │    │
│  │       url ".../lumos-linux-amd64.tar.gz"                  │    │
│  │       sha256 "f1e2d3c4b5a6..."                            │    │
│  │     elsif Hardware::CPU.arm?                              │    │
│  │       url ".../lumos-linux-arm64.tar.gz"                  │    │
│  │       sha256 "9a8b7c6d5e4f..."                            │    │
│  │   end                                                      │    │
│  │ end                                                        │    │
│  └───────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
                                                       │
                                                       │ User installs
                                                       ▼
┌─────────────────────────────────────────────────────────────────────┐
│                         End User                                    │
│                                                                     │
│  $ brew tap teamlumos/tap                                          │
│  $ brew install lumos                                              │
│                                                                     │
│  Homebrew:                                                         │
│  • Detects OS (macOS/Linux)                                        │
│  • Detects CPU (Intel/ARM)                                         │
│  • Downloads correct binary                                        │
│  • Verifies checksum                                               │
│  • Installs to /usr/local/bin/lumos                                │
│                                                                     │
│  $ lumos --version                                                 │
│  lumos version 2.1.3                                               │
└─────────────────────────────────────────────────────────────────────┘
```

## Workflow Integration

### Option 1: workflow_call (Recommended)

```yaml
# In teamlumos/lumos-cli/.github/workflows/release.yml

jobs:
  update-homebrew:
    uses: teamlumos/homebrew-tap/.github/workflows/bump-version.yml@main
    with:
      version: ${{ github.event.release.tag_name }}
      prerelease: ${{ github.event.release.prerelease }}
    secrets:
      HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

### Option 2: Manual Trigger

```
GitHub UI → Actions → Bump Homebrew Formula Version → Run workflow
├── version: 2.1.3
└── prerelease: ☐
```

## Platform Detection Flow

```
User runs: brew install lumos
         │
         ▼
Homebrew detects platform
         │
         ├─── macOS + Intel ──→ Download darwin-amd64
         ├─── macOS + ARM ────→ Download darwin-arm64
         ├─── Linux + AMD64 ─→ Download linux-amd64
         └─── Linux + ARM64 ─→ Download linux-arm64
         │
         ▼
Verify SHA256 checksum
         │
         ▼
Extract and install binary
         │
         ▼
✓ lumos available in $PATH
```

## Prerelease Handling

```
Release Type: Prerelease
         │
         ▼
Tag: 2.1.3-prerelease
         │
         ▼
Formula: Formula/lumos-prerelease.rb
         │
         ▼
Installation:
$ brew install teamlumos/tap/lumos-prerelease
```

## Directory Structure

```
teamlumos/homebrew-tap/
├── .github/
│   └── workflows/
│       └── bump-version.yml          # Main automation workflow
├── Formula/
│   ├── lumos.rb                      # Stable releases
│   └── lumos-prerelease.rb           # Prerelease versions
├── README.md                         # User + maintainer guide
├── CALLING_WORKFLOW.md               # Integration guide
├── QUICK_REFERENCE.md                # TL;DR
└── IMPLEMENTATION_SUMMARY.md         # This implementation
```

## Data Flow

```
1. Version Input
   ├── Source: GitHub Release tag
   ├── Example: "v2.1.3" or "2.1.3"
   └── Normalized: "2.1.3"

2. Asset Discovery
   ├── Repository: teamlumos/lumos-cli
   ├── Tag: 2.1.3 (or 2.1.3-prerelease)
   └── Assets: 4 platform tarballs

3. Checksum Calculation
   ├── Method: SHA256
   ├── Input: Raw tarball bytes
   └── Output: 64-char hex string

4. Formula Generation
   ├── Template: Embedded in workflow
   ├── Variables: Version, URLs, checksums
   └── Output: Formula/{lumos|lumos-prerelease}.rb

5. Git Operations
   ├── Add: Formula file
   ├── Commit: "chore: bump {name} to {version}"
   └── Push: to main branch
```

## Error Handling

```
Missing Asset
   ├── Log warning
   ├── Continue with available platforms
   └── Formula supports partial platforms

Authentication Failure
   ├── Check HOMEBREW_TAP_TOKEN
   ├── Verify token permissions
   └── Workflow fails with clear error

Checksum Mismatch (end user)
   ├── Homebrew shows error
   ├── Verify asset wasn't modified
   └── Re-run workflow to recalculate
```

## Security

```
Checksum Verification
   ├── Calculated during workflow
   ├── Embedded in formula
   └── Verified by Homebrew on install

Token Requirements
   ├── HOMEBREW_TAP_TOKEN
   ├── Scope: repo (full control)
   └── Access: teamlumos/homebrew-tap

Asset Integrity
   ├── Downloaded from GitHub
   ├── Verified SHA256
   └── No modification possible
```
