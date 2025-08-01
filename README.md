# Homebrew Forge

A comprehensive toolkit for developing, testing, and managing Homebrew formulas. Forge streamlines the entire formula development workflow from creation to distribution.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/benbenbang/homebrew-forge.git
cd homebrew-forge

# Build the forge binary
make build

# Create a new formula
./bin/forge init https://github.com/user/repo/archive/v1.0.tar.gz myapp

# Validate the formula
./bin/forge validate myapp
```

## What's Included

### Core Tools

- **Forge CLI** - Main command-line tool for formula development
- **Formula Templates** - Pre-configured formula examples
- **Testing Framework** - Automated testing and validation
- **Documentation** - Comprehensive guides and patterns

### Example Formulas

- **tomlv** - TOML validator tool (working example)

## Installation

### Access Requirements

This is a **private repository**. To use Homebrew Forge, you need:

- **GitHub account** with access to this repository
- **SSH key configured** for GitHub authentication
- **Git credentials** properly set up

```bash
# Verify GitHub access
ssh -T git@github.com

# Should return: "Hi username! You've successfully authenticated..."
```

### Prerequisites

- **Homebrew** - Required for formula operations
- **Bunster** - For building the forge binary
- **Git** - For version control and repository operations

```bash
# Install Bunster (if not already installed)
brew tap yassinebenaid/bunster
brew install bunster

# Install direnv (optional, for environment management)
brew install direnv
```

### Build from Source

```bash
# Clone and build (requires repository access)
git clone git@github.com:benbenbang/homebrew-forge.git
cd homebrew-forge
make build

# The forge binary will be available at ./bin/forge
```

### Install via Homebrew Tap

```bash
# Add the private tap (requires GitHub access)
brew tap benbenbang/forge

# Install forge
brew install forge

# Install example tools
brew install tomlv
```

## Usage

### Creating a New Formula

```bash
# Initialize formula from source URL
forge init https://github.com/user/project/archive/v1.0.tar.gz myproject

# This creates a basic formula structure that you can then customize
```

### Development Workflow

```bash
# 1. Create development structure
forge dev myproject

# 2. Edit the formula file
# Edit formula/myproject/myproject.rb

# 3. Audit for issues
forge audit myproject

# 4. Test installation
forge install myproject

# 5. Run test suite
forge test myproject

# 6. Complete validation (audit + install + test)
forge validate myproject
```

### Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `init <url> <name>` | Create initial formula | `forge init https://example.com/app.tar.gz myapp` |
| `audit <name>` | Check formula for issues | `forge audit myapp` |
| `install <name>` | Build and install from source | `forge install myapp` |
| `test <name>` | Run formula test suite | `forge test myapp` |
| `validate <name>` | Complete validation pipeline | `forge validate myapp` |
| `dev <name>` | Create development structure | `forge dev myapp` |

## Project Structure

```
homebrew-forge/
├── README.md              # This file
├── bin/                   # Executable binaries
│   ├── forge             # Compiled forge binary
│   ├── forge.sh          # Source script
│   └── completion.zsh    # Shell completions
├── formula/              # Formula files
│   └── tomlv.rb         # Example: TOML validator
├── bundles/              # Legacy formula bundles
├── dev/                  # Development utilities
├── makefile             # Build configuration
└── mise.toml            # Environment configuration
```

## Testing

### Manual Testing

```bash
# Test the forge tool itself
./bin/forge --help

# Test formula creation
./bin/forge init https://github.com/BurntSushi/toml/archive/v1.5.0.tar.gz test-formula

# Validate the test formula
./bin/forge validate test-formula
```

### Automated Testing

```bash
# Run all tests (if implemented)
make test

# Clean build artifacts
make clean
```

## Documentation

### Essential Guides

- **Formula Development** - Complete guide to creating formulas
- **Best Practices** - Recommended patterns and conventions
- **Troubleshooting** - Common issues and solutions

### Advanced Topics

- **Private Formula Distribution** - Client-specific and enterprise deployment
- **CI/CD Integration** - Automated testing and deployment
- **Custom Taps** - Creating and managing your own taps

## Examples

### Simple CLI Tool Formula

```ruby
class MyCli < Formula
  desc "My awesome CLI tool"
  homepage "https://github.com/user/mycli"
  url "https://github.com/user/mycli/archive/v1.0.0.tar.gz"
  sha256 "abc123..."
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mycli"
  end

  test do
    assert_match "version", shell_output("#{bin}/mycli --version")
  end
end
```

### Working with forge

```bash
# Create the formula
forge init https://github.com/user/mycli/archive/v1.0.0.tar.gz mycli

# Complete validation
forge validate mycli

# The tool is now ready for distribution!
```

## Contributing

### Development Setup

```bash
# Fork and clone the repository (requires access)
git clone git@github.com:yourusername/homebrew-forge.git
cd homebrew-forge

# Install dependencies
make verify

# Make your changes
# ...

# Test your changes
make build
./bin/forge --help

# Submit a pull request
```

### Code Style

- Follow existing shell scripting conventions
- Add documentation for new functions
- Include usage examples
- Test with multiple formula types

## Roadmap

### Planned Features

- [ ] **Template System** - Pre-built formula templates for common patterns
- [ ] **Dependency Analysis** - Automatic dependency detection and management
- [ ] **Multi-platform Support** - Cross-platform formula generation
- [ ] **Integration Testing** - Automated testing across multiple environments
- [ ] **Documentation Generation** - Auto-generate documentation from formulas
- [ ] **Tap Management** - Tools for managing multiple taps and releases

### Current Focus

- [x] Core forge functionality
- [x] Basic formula workflow
- [x] Example implementations (tomlv)
- [ ] Documentation and guides
- [ ] Advanced testing features

## Issues & Support

### Common Issues

**Build fails with "bunster not found"**
```bash
brew tap yassinebenaid/bunster
brew install bunster
```

**Formula fails audit**
- Check the troubleshooting guide
- Ensure all required fields are present
- Validate URL and SHA256 checksum

**Installation fails**
- Verify source URL is accessible
- Check that dependencies are available
- Review build logs for specific errors

### Getting Help

- Check the documentation
- Open an issue on GitHub
- Start a discussion

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **Homebrew Community** - For the excellent package management system
- **Bunster** - For the shell script compilation framework
- **Contributors** - Everyone who has helped improve this project

---

**Built with love by [benbenbang](https://github.com/benbenbang)**

*Forge - Crafting better Homebrew formulas, one tool at a time*
