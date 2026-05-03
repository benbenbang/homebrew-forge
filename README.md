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
./package.rb --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0

# Update SHA256s only, no version bump
./package.rb --assets benbenbang/consilium -f Formula/csl.rb

# Update git revision for source build
./package.rb --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0

# Show help
./package.rb --help
```
