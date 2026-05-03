# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Homebrew tap (`brew tap benbenbang/forge`) hosting formulas for various CLI tools. Formulas live in `Formula/` and are written in Ruby following Homebrew conventions.

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

## Formula architecture

Two patterns are used across formulas:

**Inline platform conditionals** (`Formula/csl.rb`, `Formula/pcg.rb`) — the `if OS.mac? && Hardware::CPU.arm?` chain appears directly in the formula body, with each branch providing its own `url` and `sha256`. Private repos use `GitHubPrivateRepositoryReleaseDownloadStrategy` (from `scripts/github_prv_repo_download_strategy.rb`), which reads the GitHub token from `HOMEBREW_GITHUB_API_TOKEN` or `GITHUB_TOKEN`.

**Source builds** (`Formula/uv-shell.rb`) — clone from a git tag + revision, build with `cargo`/`go`/etc., then install.

**`FormulaHelper` abstraction** (`scripts/formula_helper.rb`) — `BinaryConfig` / `SourceConfig` classes + `setup_binary` / `setup_source` class methods. Used in `examples/` and available for new formulas; reduces repetition when adding multi-platform binaries.

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
- **verify-change-sha**: fails if `Formula/*.rb` changed but no `sha256` line was modified — add the `skip-sha-check` label to bypass for non-checksum PRs
