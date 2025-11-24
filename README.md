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
  ruby ./package.rb --file Forumla/csl.rb --version 1.3.0

# Short flags
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -f Forumla/csl.rb -v 1.3.0

# Auto-detect file, just update version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -v 1.3.0

# Just update digests, don't touch version
gh release view --repo owner/repo --json "assets" --jq ".assets" | \
  ruby ./package.rb -f Forumla/csl.rb

# Show help
ruby ./package.rb --help
```
