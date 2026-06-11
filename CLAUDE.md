# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Homebrew tap (`brew tap benbenbang/forge`) hosting formulas for various CLI tools and casks for macOS apps. Formulas live in `Formula/`, casks in `Casks/`, both written in Ruby following Homebrew conventions.

## Updating a formula

The primary workflow is `package.rb` — a Ruby script that fetches release asset checksums from GitHub and patches the formula file in-place.

### Binary release (pre-built binaries)

```bash
# Update version + SHA256s
./package.rb --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0

# Update SHA256s only (no version bump)
./package.rb --assets benbenbang/consilium -f Formula/csl.rb
```

### Source build (git revision)

```bash
# Update version + git revision SHA
./package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0
```

`package.rb` calls the `gh` CLI under the hood — a working `gh auth login` is required.

## Updating a cask

Casks (macOS apps shipped as `.dmg`/`.pkg`/`.zip`) use `cask.rb` instead of `package.rb` — see [docs/cask_usage.md](docs/cask_usage.md). It reads the release asset's sha256 from GitHub and patches the cask in place.

```bash
# Update version + sha256
./cask.rb benbenbang/cclog -f Casks/cclog.rb -v 1.1.0

# Update sha256 only (no version bump)
./cask.rb benbenbang/cclog -f Casks/cclog.rb
```

A separate script is warranted because casks differ from formulae: `sha256` precedes `url`, the filename is usually `#{version}`-interpolated, and there's typically one universal artifact. `cask.rb` pairs each `url` to its nearest `sha256`, so arch-split `on_arm`/`on_intel` casks update correctly too.

## Formula architecture

Two patterns are used across formulas:

**Inline platform conditionals** (`Formula/csl.rb`, `Formula/pcg.rb`) — the `if OS.mac? && Hardware::CPU.arm?` chain appears directly in the formula body, with each branch providing its own `url` and `sha256`. Private repos use `GitHubPrivateRepositoryReleaseDownloadStrategy` (from `scripts/github_prv_repo_download_strategy.rb`), which reads the GitHub token from `HOMEBREW_GITHUB_API_TOKEN` or `GITHUB_TOKEN`.

**Source builds** (`Formula/uv-shell.rb`) — clone from a git tag + revision, build with `cargo`/`go`/etc., then install.

**`FormulaHelper` abstraction** (`scripts/formula_helper.rb`) — `BinaryConfig` / `SourceConfig` classes + `setup_binary` / `setup_source` class methods. Used in `examples/` and available for new formulas; reduces repetition when adding multi-platform binaries.

## Cask architecture

Casks distribute pre-built macOS apps. They reuse the same `GitHubPrivateRepositoryReleaseDownloadStrategy` as private formulae via `using:` on the `url` (drop it for public repos). Conventions: `sha256` before `url`, `#{version}`-interpolated filename, `desc` must not contain the platform word, `depends_on macos:` uses the bare-symbol minimum (e.g. `:catalina`), and `zap trash:` lists app-managed files. Notarized apps install without quarantine workarounds. Template: [examples/cask_example.rb](examples/cask_example.rb). End users (and the maintainer) need `HOMEBREW_GITHUB_API_TOKEN`/`GITHUB_TOKEN` to install a private cask.

## Generating a new formula

```bash
# Binary formula scaffold
ruby scripts/generate_formula.rb binary owner/repo 1.0.0 binary-name [--private]

# Source formula scaffold
ruby scripts/generate_formula.rb source owner/repo 1.0.0 [--go|--rust|--npm] [--revision SHA]
```

Output is printed to stdout — redirect to `Formula/<name>.rb`.

## Commit message format

Pre-commit enforces conventional commits:

```
<type>(<scope>): <description>
```

Types: `build`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `style`, `test`, `revert`, `hotfix`, `ops`, `chore`

## CI checks

PRs against `main` run:
- **pre-commit** hooks (yaml, trailing whitespace, JSON formatting, commit message validation)
- **verify-change-sha**: fails if `Formula/*.rb` changed but no `sha256` line was modified — add the `skip-sha-check` label to bypass for non-checksum PRs. Scoped to `Formula/**/*.rb` only, so cask-only PRs (`Casks/**/*.rb`) don't trigger it.
