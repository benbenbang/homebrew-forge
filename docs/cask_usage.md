# cask.rb Usage Guide

`cask.rb` updates a Homebrew **Cask** the same way `package.rb` updates a formula —
it reads the release asset checksum straight from GitHub and patches the cask file
in place. It's a separate script (not a `package.rb` mode) because casks differ from
formulae in three ways: `sha256` comes *before* `url`, the filename is usually
`#{version}`-interpolated, and there's typically a single universal artifact.

## When to use a cask vs. a formula

| Distribute… | Use | Lives in |
|-------------|-----|----------|
| A CLI tool / library (binary or source build) | **Formula** + `package.rb` | `Formula/` |
| A pre-built macOS app (`.dmg`/`.pkg`/`.zip`) | **Cask** + `cask.rb` | `Casks/` |

A tap hosts both at once; no extra setup beyond creating the `Casks/` directory.

## Usage

```bash
# Bump version + refresh sha256 from the new release
ruby cask.rb benbenbang/cclog -f Casks/cclog.rb -v 1.1.0

# Refresh sha256 only (asset re-uploaded under the same version)
ruby cask.rb benbenbang/cclog -f Casks/cclog.rb

# Auto-detect the cask (only one file under Casks/)
ruby cask.rb benbenbang/cclog -v 1.1.0

# Help
ruby cask.rb --help
```

**What it does:**
1. Fetches release assets via `gh release view` and reads each asset's `digest`
   (GitHub computes the sha256 automatically — no manual `shasum`).
2. Bumps the `version "…"` line (and rewrites a literal version in the `url`, for
   casks that don't interpolate `#{version}`).
3. Pairs each release asset to a `sha256` line by locating its `url` (matching the
   literal **or** `#{version}`-templated filename) and binding it to the nearest
   `sha256` — which respects the cask `sha256`-before-`url` order and keeps
   arch-split `on_arm`/`on_intel` blocks from cross-pairing.
4. Only touches assets actually referenced by a `url`, so extra release files
   (`checksums.txt`, other-platform builds) are ignored.

## Example

```bash
ruby cask.rb benbenbang/cclog -f Casks/cclog.rb -v 1.1.0
```

```
📦 Fetching release assets from benbenbang/cclog...
✓ Found release: 1.1.0
✓ Version: 1.0.0 → 1.1.0
✓ Cask 'Casks/cclog.rb' updated successfully!

📝 Updated 1 checksum(s):
  ✓ CCLog_1.1.0_universal.dmg
    4dd550b3af28975d... → <new digest>...
```

## Writing the cask

See [`examples/cask_example.rb`](../examples/cask_example.rb) for a full template.
Key points:

- **Interpolate the version in the url** (`CCLog_#{version}_universal.dmg`) so a bump
  only touches `version` + `sha256`.
- **Private repos** reuse the tap's download strategy — add
  `require_relative "../scripts/github_prv_repo_download_strategy"` at the top and
  `using: GitHubPrivateRepositoryReleaseDownloadStrategy` on the `url`. For public
  repos, drop both and Homebrew downloads directly.
- **`desc` must not contain the platform** (e.g. no "macOS") — `brew style` fails otherwise.
- **`depends_on macos:`** uses the bare symbol form for a minimum (`:catalina` is the
  oldest symbol current Homebrew accepts).
- **`zap trash:`** lists app-managed files (keyed by the app's bundle id) removed on
  `brew uninstall --zap`.

## Requirements

- GitHub CLI (`gh`) installed and authenticated (`gh auth status`).
- For a **private** cask, both the maintainer running `cask.rb` and end users running
  `brew install --cask` need a `HOMEBREW_GITHUB_API_TOKEN` (or `GITHUB_TOKEN`) with
  read access to the release repo — same as the tap's private formulae.

## Validate before committing

```bash
# Style + online audit (downloads + verifies the asset). For a private cask, export a token first:
HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)" brew audit --cask --online benbenbang/forge/<name>
brew style Casks/<name>.rb
git diff Casks/<name>.rb
```

> A cask-only PR does **not** trip the `verify-change-sha` CI check — that check is
> scoped to `Formula/**/*.rb`.

## Troubleshooting

**Warning: No sha256 values updated**
- The cask's `url` filename doesn't match any release asset. Check the asset name on
  the release vs. the `url` (remember `#{version}` expands to the version).

**Error: No SHA256 digests found in release assets**
- The release has no uploaded artifacts, or they're still processing.

**`brew install --cask` fails to download (private repo)**
- Token missing or lacks access: `export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"`.
