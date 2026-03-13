# homebrew-forge

A collection of Homebrew formulae by [@benbenbang](https://github.com/benbenbang).

## Tap

```bash
brew tap benbenbang/forge
```

## Formulae

| Formula | Description | Install |
|---|---|---|
| `uv-shell` | Create and activate Python virtual environments with uv | `brew install benbenbang/forge/uv-shell` |
| `tomlv` | TOML version manager | `brew install benbenbang/forge/tomlv` |
## To update the formula
utilize the `package.rb`

Examples:
```ruby
# Specify both file and version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb --file Formula/csl.rb --version 1.3.0

# Short flags
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -f Formula/csl.rb -v 1.3.0

# Auto-detect file, just update version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -v 1.3.0

# Just update digests, don't touch version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -f Formula/csl.rb

# Show help
ruby ./package.rb --help
```
