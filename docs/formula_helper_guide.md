# Formula Helper Guide

This guide explains how to use the FormulaHelper system to simplify creating and maintaining Homebrew formulas.

## Overview

The FormulaHelper system provides:
1. **Simplified formula syntax** - Less boilerplate code
2. **Automatic platform detection** - No need to write if/elsif chains
3. **Support for binary releases** - Pre-built binaries from GitHub releases
4. **Support for source builds** - Build from git tags (Rust, Go, npm, custom)
5. **Easy SHA256 updates** - Scripts to update hashes without manual editing

## Quick Start

### 1. Binary Release Formula

For projects that release pre-built binaries:

```ruby
require_relative "../scripts/formula_helper"

class MyTool < Formula
  desc "My awesome tool"
  homepage "https://github.com/owner/repo"
  version "1.0.0"
  license "MIT"

  SHA256S = {
    "darwin-arm64" => "abc123...",
    "darwin-amd64" => "def456...",
    "linux-arm64" => "ghi789...",
    "linux-amd64" => "jkl012..."
  }.freeze

  config = FormulaHelper::BinaryConfig.new(
    owner: "owner",
    repo: "repo",
    version: version,
    binary_name: "mytool",
    sha256s: SHA256S,
    use_private_repo: false  # Set true for private repos
  )

  FormulaHelper.setup_binary(self, config)

  test do
    assert_match "mytool", shell_output("#{bin}/mytool --help")
  end
end
```

### 2. Source Build Formula (Rust)

For Rust projects:

```ruby
require_relative "../scripts/formula_helper"

class MyRustTool < Formula
  desc "My Rust tool"
  homepage "https://github.com/owner/rust-project"
  version "1.0.0"
  license "MIT"
  head "https://github.com/owner/rust-project.git", branch: "main"

  config = FormulaHelper::SourceConfig.new(
    owner: "owner",
    repo: "rust-project",
    version: version,
    revision: "abc123def456",  # Optional: git commit SHA
    build_system: :cargo
  )

  FormulaHelper.setup_source(self, config)

  test do
    assert_match "version", shell_output("#{bin}/rust-project --version")
  end
end
```

### 3. Source Build Formula (Go)

For Go projects:

```ruby
config = FormulaHelper::SourceConfig.new(
  owner: "owner",
  repo: "go-project",
  version: version,
  build_system: :go
)

FormulaHelper.setup_source(self, config)
```

### 4. Custom Build Process

For projects with custom build requirements:

```ruby
config = FormulaHelper::SourceConfig.new(
  owner: "owner",
  repo: "custom-project",
  version: version,
  build_system: :custom,
  build_deps: ["cmake", "pkg-config"],
  install_block: proc do
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
)

FormulaHelper.setup_source(self, config)
```

## Generator Scripts

### Generate New Formula

Generate a binary formula:
```bash
ruby scripts/generate_formula.rb binary owner/repo 1.0.0 binary_name > Formula/new_formula.rb
# Add --private flag for private repos
ruby scripts/generate_formula.rb binary owner/repo 1.0.0 binary_name --private > Formula/new_formula.rb
```

Generate a source formula:
```bash
# Rust
ruby scripts/generate_formula.rb source owner/repo 1.0.0 --rust > Formula/new_formula.rb

# Go
ruby scripts/generate_formula.rb source owner/repo 1.0.0 --go > Formula/new_formula.rb

# With revision
ruby scripts/generate_formula.rb source owner/repo 1.0.0 --rust --revision abc123 > Formula/new_formula.rb
```

### Update SHA256 Hashes

Create a file with the new SHA256 hashes (`sha256s.txt`):
```
mytool-darwin-amd64: sha256:abc123...
mytool-darwin-arm64: sha256:def456...
mytool-linux-amd64: sha256:ghi789...
mytool-linux-arm64: sha256:jkl012...
```

Update the formula:
```bash
ruby scripts/update_sha256.rb Formula/mytool.rb sha256s.txt
```

Or pass hashes directly:
```bash
ruby scripts/update_sha256.rb Formula/mytool.rb 'darwin-amd64:abc123,darwin-arm64:def456,linux-amd64:ghi789,linux-arm64:jkl012'
```

## Benefits

### Before (Traditional Formula):
```ruby
class Pcg < Formula
  desc "Project configuration generator"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.5.2"
  license "Proprietary"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "a769d0bca078dd1a93636fe72d673b6a565e4b2703f4966296a96a0f9801921b"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "560ca421c619e323e7a5f31a51b8f06447cdf1734088d6ed670ebb71b41b102e"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "8e721b72667e813b3861ad3c0183e6e6311ed52a0103f0c619fd6cfbbd80e911"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4c588de017032676fbb28f165eca9e5452ff7d57a7183dd662641b7584b34585"
  end

  def install
    binary_path = cached_download
    chmod 0755, binary_path
    bin.install binary_path => "pcg"
  end

  test do
    assert_match "pcg", shell_output("#{bin}/pcg --help")
  end
end
```

### After (With FormulaHelper):
```ruby
require_relative "../scripts/formula_helper"

class Pcg < Formula
  desc "Project configuration generator"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.5.2"
  license "Proprietary"

  SHA256S = {
    "darwin-arm64" => "a769d0bca078dd1a93636fe72d673b6a565e4b2703f4966296a96a0f9801921b",
    "darwin-amd64" => "560ca421c619e323e7a5f31a51b8f06447cdf1734088d6ed670ebb71b41b102e",
    "linux-arm64" => "8e721b72667e813b3861ad3c0183e6e6311ed52a0103f0c619fd6cfbbd80e911",
    "linux-amd64" => "4c588de017032676fbb28f165eca9e5452ff7d57a7183dd662641b7584b34585"
  }.freeze

  config = FormulaHelper::BinaryConfig.new(
    owner: "benbenbang",
    repo: "prjconf-cli",
    version: version,
    binary_name: "pcg",
    sha256s: SHA256S,
    use_private_repo: true
  )

  FormulaHelper.setup_binary(self, config)

  test do
    assert_match "pcg", shell_output("#{bin}/pcg --help")
  end
end
```

**Reduction**: ~50 lines → ~25 lines, and SHA256 updates are much easier!

## Migrating Existing Formulas

To migrate an existing formula:

1. Add `require_relative "../scripts/formula_helper"` at the top
2. Extract SHA256 values into a `SHA256S` constant
3. Create a config object (BinaryConfig or SourceConfig)
4. Replace platform detection logic with `FormulaHelper.setup_binary()` or `FormulaHelper.setup_source()`
5. Keep the `test do` block unchanged

## Platform Identifiers

The helper automatically detects and uses these platform identifiers:
- `darwin-arm64` - macOS Apple Silicon
- `darwin-amd64` - macOS Intel
- `linux-arm64` - Linux ARM64
- `linux-amd64` - Linux x86_64

## Tips

1. **SHA256 Organization**: Keep SHA256 hashes in a constant at the top for easy updates
2. **Version Bumps**: Only need to change `version` and `SHA256S` for new releases
3. **Automation**: Use the update script in CI/CD to automate hash updates
4. **Testing**: Always test formulas after generation with `brew install --build-from-source`

## Troubleshooting

**Q: Formula fails with "undefined method" error**
A: Make sure you have `require_relative "../scripts/formula_helper"` at the top

**Q: SHA256 update script doesn't find hashes**
A: Check that your hash file format matches the expected format

**Q: Build fails for source formula**
A: Verify the build system is correctly specified and dependencies are available

## Examples

See the `examples/` directory for complete working examples:
- `binary_formula_example.rb` - Binary release examples
- `source_formula_example.rb` - Source build examples (Rust, Go, custom)
