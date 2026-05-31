# homebrew-forge

## Installation

```bash
brew tap benbenbang/forge
brew install benbenbang/forge/tomlv
```
## To update the formula
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
