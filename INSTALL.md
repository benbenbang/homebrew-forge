# Installing from homebrew-forge (Private Tap)

This guide explains how to install tools from the `benbenbang/homebrew-forge` private Homebrew tap.

## Prerequisites

### 1. Access Requirements

- **GitHub account** with access to this private repository
- **SSH key configured** for GitHub authentication
- **Git credentials** properly set up

```bash
# Verify GitHub access
ssh -T git@github.com
# Should return: "Hi username! You've successfully authenticated..."
```

### 2. Required Software

- **Homebrew** - macOS/Linux package manager
- **Git** - Version control (usually pre-installed)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Authentication Setup

### Create GitHub Personal Access Token

1. Go to [GitHub Settings → Developer Settings → Personal Access Tokens](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. Set **Expiration** (recommend 90 days or longer)
4. Select these **permissions**:
   - ✅ `repo` (Full control of private repositories)
   - ✅ `read:packages` (Read packages)
5. Click **"Generate token"**
6. **Copy the token** immediately (you won't see it again!)

### Configure Environment

Add your token to your shell profile:

```bash
# For zsh (macOS default)
echo 'export HOMEBREW_GITHUB_API_TOKEN="your_token_here"' >> ~/.zshrc
source ~/.zshrc

# For bash
echo 'export HOMEBREW_GITHUB_API_TOKEN="your_token_here"' >> ~/.bash_profile
source ~/.bash_profile
```

**⚠️ Security Note**: Keep your token secure and never commit it to code repositories.

## Installation

### Step 1: Add the Private Tap

```bash
# Add the private tap using SSH (recommended for private repos)
brew tap benbenbang/forge git@github.com:benbenbang/homebrew-forge.git
```

### Step 2: Install Tools

```bash
# Install preconf-cli (pre-commit configuration generator)
brew install preconf-cli

# Verify installation
pcg --help
```

## Available Tools

### preconf-cli (pcg)

Pre-commit configuration generator for development workflows.

```bash
# Install
brew install preconf-cli

# Usage
pcg --help
pcg init    # Generate pre-commit configuration
```

## Usage Examples

### Basic Usage

```bash
# Generate a new pre-commit configuration
pcg init

# Use with specific project types
pcg init --type golang
pcg init --type python
pcg init --type node
```

### Integration with Projects

```bash
# In your project directory
cd my-project
pcg init
git add .pre-commit-config.yaml
git commit -m "Add pre-commit configuration"

# Install pre-commit hooks
pre-commit install
```

## Updating

### Update the Tap

```bash
# Update tap to get latest formulas
brew update

# Upgrade installed packages
brew upgrade preconf-cli
```

### Update Tools

```bash
# Upgrade specific tool
brew upgrade preconf-cli

# Upgrade all tools from this tap
brew upgrade benbenbang/forge/preconf-cli
```

## Troubleshooting

### Common Issues

#### ❌ "Authentication failed"

```bash
# Verify token is set
echo $HOMEBREW_GITHUB_API_TOKEN

# Re-export token if needed
export HOMEBREW_GITHUB_API_TOKEN="your_token_here"
```

#### ❌ "Permission denied"

```bash
# Verify SSH access to GitHub
ssh -T git@github.com

# Re-add tap if needed
brew untap benbenbang/forge
brew tap benbenbang/forge git@github.com:benbenbang/homebrew-forge.git
```

#### ❌ "Formula not found"

```bash
# Update tap
brew update

# List available formulas
brew search benbenbang/forge/
```

#### ❌ "Checksum mismatch"

This usually means the release binaries have been updated but the formula hasn't. Please:

1. Check if there's a newer version available
2. Report the issue to the maintainer
3. Try reinstalling: `brew uninstall preconf-cli && brew install preconf-cli`

### Getting Help

1. **Check the logs**:
   ```bash
   brew install --verbose --debug preconf-cli
   ```

2. **Verify tap status**:
   ```bash
   brew tap-info benbenbang/forge
   ```

3. **Clean and retry**:
   ```bash
   brew cleanup
   brew doctor
   ```

## Removing

### Uninstall Tools

```bash
# Uninstall specific tool
brew uninstall preconf-cli

# Remove tap entirely
brew untap benbenbang/forge
```

## Development

### For Contributors

If you're contributing to this tap:

```bash
# Clone the repository
git clone git@github.com:benbenbang/homebrew-forge.git
cd homebrew-forge

# Build forge CLI
make build

# Test formulas
./bin/forge validate preconf-cli
```

### Local Testing

```bash
# Test formula locally without installing
brew audit --new Formula/preconf-cli.rb

# Install from local file
brew install --build-from-source Formula/preconf-cli.rb
```

## Security

- **Never share your GitHub token**
- **Use tokens with minimal necessary permissions**
- **Rotate tokens regularly (every 90 days)**
- **Revoke tokens when no longer needed**

## Support

- **Issues**: Open an issue on the GitHub repository
- **Questions**: Start a discussion on GitHub
- **Documentation**: Check the main [README.md](README.md)

---

**Built with ❤️ by [benbenbang](https://github.com/benbenbang)**

*Making development workflows easier, one tool at a time.*