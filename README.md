# homebrew-forge

## Installation

```bash
brew tap benbenbang/forge

# Formula (CLI tool)
brew install benbenbang/forge/tomlv

# Cask (macOS app)
brew install --cask benbenbang/forge/cclog
```

> Private formulae/casks need a token with repo access:
> `export HOMEBREW_GITHUB_API_TOKEN="$(gh auth token)"`

## To update a formula
utilize the `package.rb`

Examples:
```bash
# Update version + SHA256s (binary release)
ruby package.rb --assets benbenbang/prjconf-cli -f Formula/pcg.rb -v 1.11.0

# Update SHA256s only, no version bump
ruby ./package.rb --assets benbenbang/consilium -f Formula/csl.rb

# Update git revision for source build
ruby ./package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0

# Show help
ruby ./package.rb --help
```

## To update a cask
utilize the `cask.rb` (see [docs/cask_usage.md](docs/cask_usage.md))

```bash
# Bump version + refresh sha256 from the new release
ruby cask.rb benbenbang/cclog -f Casks/cclog.rb -v 1.1.0

# Refresh sha256 only, no version bump
ruby cask.rb benbenbang/cclog -f Casks/cclog.rb

# Show help
ruby cask.rb --help
```
