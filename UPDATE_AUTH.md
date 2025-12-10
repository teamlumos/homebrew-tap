# Authentication Update: GitHub App vs PAT

## Summary

Updated the `bump-version.yml` workflow to use **GitHub App authentication** instead of a Personal Access Token (PAT). This aligns with the existing authentication pattern used in the `teamlumos/lumos-cli` release workflow.

---

## Changes Made

### Workflow Updates

**Before (PAT):**
```yaml
secrets:
  HOMEBREW_TAP_TOKEN:
    required: true

steps:
  - uses: actions/checkout@v4
    with:
      token: ${{ secrets.HOMEBREW_TAP_TOKEN || secrets.GITHUB_TOKEN }}
  
  # ...
  
  - name: Commit and push
    run: |
      git config user.name "github-actions[bot]"
      git config user.email "github-actions[bot]@users.noreply.github.com"
      git push
```

**After (GitHub App):**
```yaml
secrets:
  GH_BOT_CLIENT_ID:
    required: true
  GH_BOT_PRIVATE_KEY:
    required: true

steps:
  - name: Generate GitHub App token
    id: app-token
    uses: actions/create-github-app-token@v2
    with:
      app-id: ${{ secrets.GH_BOT_CLIENT_ID }}
      private-key: ${{ secrets.GH_BOT_PRIVATE_KEY }}

  - name: Get bot user ID
    id: bot-user-id
    env:
      GH_TOKEN: ${{ steps.app-token.outputs.token }}
    run: |
      echo "user-id=$(gh api "/users/${{ steps.app-token.outputs.app-slug }}[bot]" --jq .id)" >> "$GITHUB_OUTPUT"

  - uses: actions/checkout@v4
    with:
      token: ${{ steps.app-token.outputs.token }}
      persist-credentials: false
  
  # ...
  
  - name: Commit and push
    env:
      GH_TOKEN: ${{ steps.app-token.outputs.token }}
      GIT_AUTHOR_EMAIL: "${{ steps.bot-user-id.outputs.user-id }}+${{ steps.app-token.outputs.app-slug }}[bot]@users.noreply.github.com"
      GIT_COMMITTER_EMAIL: "${{ steps.bot-user-id.outputs.user-id }}+${{ steps.app-token.outputs.app-slug }}[bot]@users.noreply.github.com"
      GIT_AUTHOR_NAME: "${{ steps.app-token.outputs.app-slug }}[bot]"
      GIT_COMMITTER_NAME: "${{ steps.app-token.outputs.app-slug }}[bot]"
    run: |
      git config user.name "$GIT_AUTHOR_NAME"
      git config user.email "$GIT_AUTHOR_EMAIL"
      git push
```

---

## Benefits

### GitHub App vs PAT

| Feature | PAT | GitHub App |
|---------|-----|------------|
| **Scope** | User-level | Organization-level |
| **Expiration** | Manual renewal | No expiration |
| **Attribution** | Personal account | Bot identity |
| **Permissions** | Broad (`repo`) | Fine-grained |
| **Rotation** | Manual process | Automated |
| **Audit trail** | Tied to user | Clear bot actions |

### Specific Advantages

1. **Consistency**: Uses same authentication as release workflow
2. **Security**: No need to create/manage separate PAT
3. **Maintainability**: Centralized app management
4. **Attribution**: Commits clearly show bot identity
5. **Permissions**: Fine-grained control at app level

---

## Integration Changes

### For CLI Repository Maintainers

**Old Integration:**
```yaml
secrets:
  HOMEBREW_TAP_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
```

**New Integration:**
```yaml
secrets:
  GH_BOT_CLIENT_ID: ${{ secrets.GH_BOT_CLIENT_ID }}
  GH_BOT_PRIVATE_KEY: ${{ secrets.GH_BOT_PRIVATE_KEY }}
```

**Important:** These are the **same secrets** already used in your release workflow, so no new setup is required!

---

## Migration Steps

### For `teamlumos/lumos-cli`

✅ **No action needed!** The GitHub App secrets (`GH_BOT_CLIENT_ID` and `GH_BOT_PRIVATE_KEY`) should already exist from your release workflow.

Just verify:
1. Go to Settings → Secrets → Actions
2. Confirm `GH_BOT_CLIENT_ID` exists
3. Confirm `GH_BOT_PRIVATE_KEY` exists
4. Ensure the GitHub App is installed on the `teamlumos` organization
5. Verify the app has write access to `homebrew-tap` repository

---

## What Changed in Documentation

Updated references in all docs:

- ❌ **Removed:** `HOMEBREW_TAP_TOKEN` (PAT)
- ✅ **Added:** `GH_BOT_CLIENT_ID` and `GH_BOT_PRIVATE_KEY` (GitHub App)

### Files Updated:
1. `.github/workflows/bump-version.yml` - Workflow implementation
2. `README.md` - Main documentation
3. `QUICKSTART.md` - Quick setup guide
4. `QUICK_REFERENCE.md` - Code snippets
5. `CALLING_WORKFLOW.md` - Integration guide
6. `TESTING_CHECKLIST.md` - Testing procedures
7. `IMPLEMENTATION_SUMMARY.md` - Technical details
8. `SUMMARY.md` - Project overview
9. `READY_FOR_REVIEW.md` - Review checklist
10. `MIGRATION.md` - Migration guide
11. `ARCHITECTURE.md` - System design

---

## Example: GitHub App Setup

If you need to verify or set up the GitHub App (though it should already exist):

### 1. GitHub App Configuration

The app should have these permissions:
- **Repository permissions:**
  - Contents: Read and write
  - Metadata: Read-only

### 2. App Installation

- Installed on: `teamlumos` organization
- Repository access: `teamlumos/homebrew-tap`

### 3. Secrets

In `teamlumos/lumos-cli` repository:
- `GH_BOT_CLIENT_ID`: The App ID (numeric)
- `GH_BOT_PRIVATE_KEY`: The App private key (PEM format)

---

## Verification

### Check Workflow Runs

After merging, commits will show:
- **Author:** `lumos-automations[bot]` (or your app name)
- **Email:** `{user-id}+{app-slug}[bot]@users.noreply.github.com`

### Compare with Release Workflow

The authentication pattern should match exactly with your existing release workflow in `teamlumos/lumos-cli`.

---

## Troubleshooting

### "App not found" Error

**Solution:**
- Verify `GH_BOT_CLIENT_ID` is correct
- Check the App exists in your organization
- Ensure the App is installed on the organization

### "Insufficient permissions" Error

**Solution:**
- Verify the App has write access to `homebrew-tap`
- Check the App's repository permissions include "Contents: Read and write"

### "Invalid private key" Error

**Solution:**
- Regenerate private key in App settings
- Update `GH_BOT_PRIVATE_KEY` secret with new key
- Ensure key is in PEM format with newlines preserved

---

## Rollback Plan

If issues arise, you can temporarily revert to PAT authentication:

1. Revert the workflow file to previous version
2. Create a PAT with `repo` scope
3. Add as `HOMEBREW_TAP_TOKEN` secret
4. Update workflow call to use `HOMEBREW_TAP_TOKEN`

However, **GitHub App is preferred** for the benefits listed above.

---

## References

- [GitHub Apps documentation](https://docs.github.com/en/apps)
- [actions/create-github-app-token](https://github.com/actions/create-github-app-token)
- Example reference from `teamlumos/lumos-cli` release workflow

---

**Status:** ✅ **Complete and Ready**

All documentation has been updated to reflect GitHub App authentication. No additional setup is required if the CLI repository already has the GitHub App secrets configured.
