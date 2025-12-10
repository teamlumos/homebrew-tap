# 🚀 Quick Start Guide

## For Developers Using the CLI

**Nothing changes for you!**

```bash
brew tap teamlumos/tap
brew install lumos
```

Now works on:
- ✅ macOS Intel
- ✅ macOS Apple Silicon (M1/M2/M3)
- ✅ Linux AMD64
- ✅ Linux ARM64

---

## For CLI Repository Maintainers

### Step 1: Add Secret (One-time setup)

1. Go to https://github.com/teamlumos/lumos-cli/settings/secrets/actions
2. Click "New repository secret"
3. Name: `HOMEBREW_TAP_TOKEN`
4. Value: [Create a GitHub PAT](https://github.com/settings/tokens) with `repo` scope
5. Click "Add secret"

### Step 2: Update Release Workflow

Add this to your `.github/workflows/release.yml`:

```yaml
jobs:
  # ... your existing build job ...

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

### Step 3: Ensure Release Assets Match

Your release must include these files:
```
lumos-darwin-amd64.tar.gz
lumos-darwin-arm64.tar.gz
lumos-linux-amd64.tar.gz
lumos-linux-arm64.tar.gz
```

Each tarball = one `lumos` binary at root level.

### Step 4: Test It

1. Create a test release
2. Watch the workflow run in Actions
3. Verify the formula updates
4. Test installation: `brew install teamlumos/tap/lumos`

---

## For Homebrew Tap Maintainers

### Manual Trigger

Need to bump version manually?

1. Go to https://github.com/teamlumos/homebrew-tap/actions/workflows/bump-version.yml
2. Click "Run workflow"
3. Enter version (e.g., `2.1.3`)
4. Check "prerelease" if needed
5. Click "Run workflow"

Done! The formula updates automatically.

---

## 📚 Need More Details?

| Document | What's in it |
|----------|--------------|
| `QUICK_REFERENCE.md` | Copy-paste code snippets |
| `CALLING_WORKFLOW.md` | Full integration guide |
| `TESTING_CHECKLIST.md` | How to test everything |
| `MIGRATION.md` | What changed from old workflow |
| `ARCHITECTURE.md` | System design diagrams |

---

## 🆘 Troubleshooting

**Problem:** Workflow fails with "Asset not found"  
**Fix:** Check your release has all 4 platform tarballs

**Problem:** "Permission denied" when pushing  
**Fix:** Verify `HOMEBREW_TAP_TOKEN` is set and has `repo` scope

**Problem:** Checksum mismatch on install  
**Fix:** Re-run the workflow to recalculate checksums

---

## ✅ Success Checklist

- [ ] Secret added to CLI repo
- [ ] Release workflow updated
- [ ] Release assets have correct names
- [ ] Test release created
- [ ] Formula updated automatically
- [ ] Installation works on your platform

---

**Questions?** Open an issue or check the docs!
