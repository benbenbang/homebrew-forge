# homebrew-forge

## Installation

```bash
brew tap benbenbang/forge
brew install benbenbang/forge/tomlv
```
## To update the formula
utilize the `package.rb`

Examples:
```ruby
# Specify both file and version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ./package.rb --file csl.rb --version 1.3.0

# Short flags
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ./package.rb -f csl.rb -v 1.3.0

# Auto-detect file, just update version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ./package.rb -v 1.3.0

# Just update digests, don't touch version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ./package.rb -f csl.rb

# Show help
./package.rb --help
```
