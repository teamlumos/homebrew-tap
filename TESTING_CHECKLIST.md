# Testing Checklist

Before deploying this update to production, complete this checklist.

## ✅ Pre-Merge Checklist

### Workflow Validation

- [x] YAML syntax is valid
- [x] All required inputs are defined
- [x] Both `workflow_dispatch` and `workflow_call` triggers are configured
- [x] Secrets are properly defined
- [x] Checkout uses correct token
- [x] Git config is set for commits

### Formula Validation

- [ ] Ruby syntax is valid (requires Ruby to test)
- [x] Multi-platform blocks are correct (`on_macos`, `on_linux`)
- [x] CPU detection is correct (`Hardware::CPU.intel?`, `Hardware::CPU.arm?`)
- [x] URLs point to `teamlumos/lumos-cli` (not `homebrew-tap`)
- [x] Install method is simple (`bin.install "lumos"`)
- [x] Test block is present

### Documentation

- [x] `README.md` has user installation instructions
- [x] `README.md` has maintainer integration guide
- [x] `QUICK_REFERENCE.md` provides TL;DR
- [x] `CALLING_WORKFLOW.md` has detailed integration steps
- [x] `IMPLEMENTATION_SUMMARY.md` documents what was built
- [x] `ARCHITECTURE.md` shows system design
- [x] `MIGRATION.md` explains changes from old workflow

---

## 🧪 Post-Merge Testing

### Test 1: Manual Trigger (Dry Run)

```bash
# Go to GitHub UI
# Actions → Bump Homebrew Formula Version → Run workflow
# - version: 2.1.2
# - prerelease: false
# Expected: No changes (already at 2.1.2)
```

**Expected Result:**
- ✅ Workflow completes successfully
- ✅ "No changes to commit" message
- ✅ No new commits

### Test 2: Prerelease Version Bump

Create a test prerelease in `teamlumos/lumos-cli`:

```bash
# In teamlumos/lumos-cli
git tag 2.1.3-test
# Create release with tag 2.1.3-test, mark as prerelease
# Upload dummy tarballs for all 4 platforms
```

**Expected Result:**
- ✅ Workflow triggered automatically (if integrated)
- ✅ Downloads all 4 platform assets
- ✅ Calculates checksums
- ✅ Updates `Formula/lumos-prerelease.rb`
- ✅ Commits with message: "chore: bump lumos-prerelease to 2.1.3"
- ✅ Formula version is 2.1.3
- ✅ Formula URLs point to tag `2.1.3-test-prerelease`

### Test 3: Stable Version Bump

Create a test release in `teamlumos/lumos-cli`:

```bash
# In teamlumos/lumos-cli
git tag 2.1.3
# Create release with tag 2.1.3, NOT prerelease
# Upload dummy tarballs for all 4 platforms
```

**Expected Result:**
- ✅ Workflow triggered automatically (if integrated)
- ✅ Downloads all 4 platform assets
- ✅ Calculates checksums
- ✅ Updates `Formula/lumos.rb`
- ✅ Commits with message: "chore: bump lumos to 2.1.3"
- ✅ Formula version is 2.1.3
- ✅ Formula URLs point to tag `2.1.3`

### Test 4: Missing Assets

Create a release with only 2 platform assets (e.g., macOS only):

**Expected Result:**
- ✅ Workflow logs warnings for missing assets
- ✅ Continues with available assets
- ✅ Formula updated with checksums for available platforms
- ✅ Formula has placeholder checksums for missing platforms

### Test 5: Installation (macOS Intel)

On a macOS Intel machine:

```bash
brew tap teamlumos/tap
brew install lumos
lumos --version
```

**Expected Result:**
- ✅ Downloads darwin-amd64 tarball
- ✅ Verifies checksum
- ✅ Installs to /usr/local/bin/lumos
- ✅ Binary is executable
- ✅ Version command works

### Test 6: Installation (macOS ARM)

On a macOS ARM machine (M1/M2/M3):

```bash
brew tap teamlumos/tap
brew install lumos
lumos --version
```

**Expected Result:**
- ✅ Downloads darwin-arm64 tarball
- ✅ Verifies checksum
- ✅ Installs to /opt/homebrew/bin/lumos
- ✅ Binary is executable
- ✅ Version command works

### Test 7: Installation (Linux AMD64)

On a Linux x86_64 machine:

```bash
# Install Homebrew if not present
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap teamlumos/tap
brew install lumos
lumos --version
```

**Expected Result:**
- ✅ Downloads linux-amd64 tarball
- ✅ Verifies checksum
- ✅ Installs to ~/.linuxbrew/bin/lumos
- ✅ Binary is executable
- ✅ Version command works

### Test 8: Installation (Linux ARM64)

On a Linux ARM64 machine (Raspberry Pi, AWS Graviton):

```bash
brew tap teamlumos/tap
brew install lumos
lumos --version
```

**Expected Result:**
- ✅ Downloads linux-arm64 tarball
- ✅ Verifies checksum
- ✅ Installs correctly
- ✅ Binary is executable
- ✅ Version command works

### Test 9: Prerelease Installation

```bash
brew tap teamlumos/tap
brew install lumos-prerelease
lumos --version
```

**Expected Result:**
- ✅ Installs prerelease version
- ✅ Binary works correctly
- ✅ Version matches prerelease tag

### Test 10: Formula Audit

```bash
brew audit --strict --online teamlumos/tap/lumos
brew audit --strict --online teamlumos/tap/lumos-prerelease
```

**Expected Result:**
- ✅ No errors
- ✅ No warnings (or only acceptable warnings)

### Test 11: Formula Test

```bash
brew test teamlumos/tap/lumos
brew test teamlumos/tap/lumos-prerelease
```

**Expected Result:**
- ✅ Test passes
- ✅ Version command works

---

## 🔧 CLI Repository Setup Checklist

After merging this PR, complete these steps in `teamlumos/lumos-cli`:

### Required Changes

- [ ] Verify GitHub App secrets exist
  - Go to Settings → Secrets → Actions
  - Verify: `GH_BOT_CLIENT_ID` (GitHub App ID)
  - Verify: `GH_BOT_PRIVATE_KEY` (GitHub App private key)
  - These should already exist from your release workflow
  
- [ ] Update `release.yml` workflow
  - Add `update-homebrew` job
  - Use `workflow_call` to trigger bump-version.yml
  - Pass version and prerelease flag
  
- [ ] Ensure release assets match naming convention
  - `lumos-darwin-amd64.tar.gz`
  - `lumos-darwin-arm64.tar.gz`
  - `lumos-linux-amd64.tar.gz`
  - `lumos-linux-arm64.tar.gz`
  
- [ ] Verify tarball structure
  - Each tarball contains single `lumos` binary at root
  - No subdirectories or wrapper scripts

### Integration Test

- [ ] Create test release in CLI repo
- [ ] Verify workflow triggers
- [ ] Verify formula updates
- [ ] Test installation on at least one platform

---

## 🐛 Common Issues & Solutions

### Issue: "Asset not found"

**Cause:** Release doesn't have all platform binaries

**Fix:**
```bash
# Check release assets
gh release view v2.1.3 --repo teamlumos/lumos-cli

# Should see all 4 files:
# - lumos-darwin-amd64.tar.gz
# - lumos-darwin-arm64.tar.gz
# - lumos-linux-amd64.tar.gz
# - lumos-linux-arm64.tar.gz
```

### Issue: "Permission denied" when pushing

**Cause:** Invalid GitHub App credentials or insufficient permissions

**Fix:**
```bash
# Verify GitHub App configuration:
# 1. Check GH_BOT_CLIENT_ID and GH_BOT_PRIVATE_KEY secrets are set
# 2. Verify the GitHub App is installed on teamlumos organization
# 3. Verify the app has write access to homebrew-tap repository
# 4. Check the private key is valid and not expired
```

### Issue: Checksum mismatch on install

**Cause:** Binary was modified after upload, or checksum calculated incorrectly

**Fix:**
```bash
# Re-trigger workflow to recalculate checksums
# Or manually calculate:
sha256sum lumos-darwin-amd64.tar.gz
# Update formula manually if needed
```

### Issue: Formula syntax error

**Cause:** Invalid Ruby syntax

**Fix:**
```bash
# Check syntax locally
ruby -c Formula/lumos.rb

# Or use Homebrew's linter
brew audit --strict Formula/lumos.rb
```

---

## 📊 Success Metrics

After full deployment, verify:

- [ ] ✅ Workflow runs successfully on every release
- [ ] ✅ Formula updates automatically without manual intervention
- [ ] ✅ Users can install on all 4 platforms
- [ ] ✅ No checksum errors reported
- [ ] ✅ Installation time is fast (<2 minutes)
- [ ] ✅ No manual formula updates needed

---

## 🎯 Rollback Plan

If issues occur:

1. **Immediate:** Revert PR in `homebrew-tap`
2. **Short-term:** Use manual workflow trigger with correct values
3. **Long-term:** Fix issues and re-deploy

---

## 📝 Sign-off

**Tested by:** _________________

**Date:** _________________

**Platforms tested:**
- [ ] macOS Intel
- [ ] macOS ARM
- [ ] Linux AMD64
- [ ] Linux ARM64

**Issues found:** _________________

**Ready for production:** ☐ Yes ☐ No

---

## 🚀 Deployment Steps

1. **Merge this PR** to `main` in `homebrew-tap`
2. **Set up secrets** in CLI repository
3. **Update release workflow** in CLI repository
4. **Create test release** to verify integration
5. **Monitor first production release**
6. **Announce** to team that multi-platform support is live

---

## 📞 Support

If you encounter issues during testing:

1. Check `MIGRATION.md` for migration guide
2. Review `CALLING_WORKFLOW.md` for integration details
3. Check workflow logs in GitHub Actions
4. Open issue in `teamlumos/homebrew-tap` with:
   - Workflow run URL
   - Error messages
   - Steps to reproduce
