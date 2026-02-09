# package.rb Usage Guide

The `package.rb` script has been updated to simplify formula updates!

## What Changed

### Before (Required Piping):
```bash
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb --file Formula/csl.rb --version 1.3.0
```

### After (No Piping Needed):
```bash
# Update binary SHA256s
ruby package.rb --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0

# Update git revision for source builds
ruby package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0
```

## Features

✅ **No more piping** - Script fetches GitHub data itself using `gh` CLI
✅ **Two modes** - `--assets` for binaries, `--revision` for source builds
✅ **Auto-detection** - Can find formula file automatically if there's only one
✅ **Better output** - Shows what was updated with emoji indicators

## Usage

### Mode 1: Update Binary SHA256s (`--assets`)

For formulas that use pre-built binary releases (like `csl.rb`, `pcg.rb`):

```bash
# Full command
ruby package.rb --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0

# Auto-detect formula (if only one .rb file in current dir or Formula/)
ruby package.rb --assets benbenbang/consilium -v 1.3.0

# Update SHA256s without changing version
ruby package.rb --assets benbenbang/consilium -f Formula/csl.rb
```

**What it does:**
1. Fetches release assets from GitHub using `gh release view`
2. Extracts SHA256 digests from assets
3. Updates all matching `sha256` lines in the formula
4. Optionally updates the version number

### Mode 2: Update Git Revision (`--revision`)

For formulas that build from source (like `uv-shell.rb`):

```bash
# Full command
ruby package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0

# Can also use --tag (alias for --revision)
ruby package.rb --tag benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0
```

**What it does:**
1. Fetches the git commit SHA for the specified tag (v{version})
2. Updates the `revision:` line in the formula
3. Updates the version number

**Note:** Version is required for `--revision` mode.

## Requirements

- GitHub CLI (`gh`) must be installed: `brew install gh`
- You must be authenticated: `gh auth login`
- For private repos, you need appropriate access

## Examples

### Example 1: Update CSL Binary Formula
```bash
# When new version 1.3.0 is released
ruby package.rb --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0
```

**Output:**
```
✓ Version updated to 1.3.0
📦 Fetching release assets from benbenbang/consilium...
✓ Formula 'Formula/csl.rb' updated successfully!

📝 Updated 4 digest(s):
  ✓ csl-darwin-arm64
    bb163ff88e5623954315f632f8e41c78669b7bbfce78033dc586f1645d0b626e... → b5f59391193fab68...
  ✓ csl-darwin-amd64
    d92554d1ead14401... → bf25191e6a63b103...
  ✓ csl-linux-arm64
    1623297337d499eb... → a37480d47da3b77c...
  ✓ csl-linux-amd64
    05d0e828341f2abe... → 5920d53c715e251f...
```

### Example 2: Update UV-Shell Source Formula
```bash
# When new version 2.1.0 is released
ruby package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.1.0
```

**Output:**
```
✓ Version updated to 2.1.0
🔍 Fetching git revision for benbenbang/uv-shell v2.1.0...
✓ Formula 'Formula/uv-shell.rb' updated successfully!

📝 Updated git revision:
  534df113 → a1b2c3d4
  (534df113f0c3f56f50d45a8c683100a7ce7f0dad → a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0)
```

### Example 3: Auto-detect Formula
```bash
# If you're in a directory with only one .rb file
cd Formula/
ruby ../package.rb --assets benbenbang/consilium -v 1.3.0
# Automatically finds and updates the single .rb file
```

## Comparison

| Feature | Old Way | New Way |
|---------|---------|---------|
| **Pipe required** | ✅ Yes | ❌ No |
| **Command length** | ~2 lines | 1 line |
| **Update assets** | ✅ Yes | ✅ Yes |
| **Update revision** | ❌ No | ✅ Yes |
| **Auto-detect file** | ✅ Yes | ✅ Yes |
| **Fetch GitHub data** | Manual (`gh` + pipe) | Automatic |

## Help

```bash
ruby package.rb --help
```

Shows all options and examples.

## Troubleshooting

**Error: GitHub CLI (gh) is not installed**
```bash
brew install gh
```

**Error: Failed to fetch release from GitHub**
- Check if you're authenticated: `gh auth status`
- Check if the repository exists and is accessible
- For private repos, make sure you have access

**Error: No SHA256 digests found in release assets**
- Make sure the GitHub release has assets attached
- Assets need to have SHA256 checksums available

**Error: Could not find revision line in formula**
- Make sure the formula has a `revision:` line
- This error happens when using `--revision` on a binary formula

## Tips

1. **Use version carefully**: The script assumes tags are formatted as `v{version}` (e.g., `v1.3.0`)
2. **Check before committing**: Always review the changes with `git diff` before committing
3. **Works with private repos**: As long as you're authenticated with `gh`
