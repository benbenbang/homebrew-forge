# Formula Helper System - Summary

I've created a comprehensive system to simplify your Homebrew formula management! 🎉

## What's New

### 1. FormulaHelper Module (`scripts/formula_helper.rb`)
A powerful helper that handles both binary releases and source builds with minimal code.

**Key Features:**
- ✅ Automatic platform detection (macOS Intel/ARM, Linux Intel/ARM)
- ✅ Auto-generates download URLs from owner/repo
- ✅ Supports both binary releases and source builds
- ✅ Build system detection (Cargo/Rust, Go, npm, custom)
- ✅ Private repository support

### 2. Formula Generator (`scripts/generate_formula.rb`)
Generate new formulas with a single command!

**Usage:**
```bash
# Binary formula
./scripts/generate_formula.rb binary owner/repo 1.0.0 binary_name > Formula/new.rb
./scripts/generate_formula.rb binary owner/repo 1.0.0 binary_name --private > Formula/new.rb

# Source formula (Rust)
./scripts/generate_formula.rb source owner/repo 1.0.0 --rust > Formula/new.rb

# Source formula (Go)
./scripts/generate_formula.rb source owner/repo 1.0.0 --go > Formula/new.rb

# With git revision
./scripts/generate_formula.rb source owner/repo 1.0.0 --rust --revision abc123 > Formula/new.rb
```

### 3. SHA256 Updater (`scripts/update_sha256.rb`)
Update SHA256 hashes without manual editing!

**Usage:**
```bash
# From file
./scripts/update_sha256.rb Formula/mytool.rb sha256s.txt

# Direct input
./scripts/update_sha256.rb Formula/csl.rb 'darwin-amd64:abc,darwin-arm64:def,...'
```

**File format (`sha256s.txt`):**
```
tool-darwin-amd64: sha256:abc123...
tool-darwin-arm64: sha256:def456...
tool-linux-amd64: sha256:ghi789...
tool-linux-arm64: sha256:jkl012...
```

## Your Questions Answered

### 1. Just pass owner/repo and let script handle the rest?
**YES!** ✅

With the new system:
- Just specify `owner`, `repo`, `version`, and `binary_name`
- URLs are automatically generated
- Platform detection is automatic
- No more copy-pasting if/elsif chains

### 2. Choose between assets or build from tag/revision?
**YES!** ✅

The system supports both:

**For binary releases (assets):**
```ruby
config = FormulaHelper::BinaryConfig.new(
  owner: "benbenbang",
  repo: "consilium",
  version: version,
  binary_name: "csl",
  sha256s: SHA256S
)
FormulaHelper.setup_binary(self, config)
```

**For source builds (no assets):**
```ruby
config = FormulaHelper::SourceConfig.new(
  owner: "benbenbang",
  repo: "uv-shell",
  version: version,
  revision: "abc123",  # Optional: git commit SHA
  build_system: :cargo  # or :go, :npm, :custom
)
FormulaHelper.setup_source(self, config)
```

## Example Comparison

### Old Way (50+ lines):
```ruby
class Csl < Formula
  # ... metadata ...

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "bb163ff88e5623954315f632f8e41c78669b7bbfce78033dc586f1645d0b626e"
  elsif OS.mac? && Hardware::CPU.intel?
    # ... repeat for each platform ...
  end

  def install
    binary_path = cached_download
    chmod 0755, binary_path
    bin.install binary_path => "csl"
  end
end
```

### New Way (25 lines):
```ruby
require_relative "../scripts/formula_helper"

class Csl < Formula
  desc "Consilium CLI"
  homepage "https://github.com/benbenbang/consilium"
  version "1.9.0"
  license "Proprietary"

  SHA256S = {
    "darwin-arm64" => "b5f59391193fab683b6e4efe1e31441dbab9353a35ca1dd2b583251872673ca5",
    "darwin-amd64" => "bf25191e6a63b1033c816416d24fdb73b2b26341adc0569245c67e81aa4909d2",
    "linux-arm64" => "a37480d47da3b77c963182839f190e9585d0ea427b53c73ff6acb558379a54dc",
    "linux-amd64" => "5920d53c715e251f01fa47c47f9da1eff67a593a8d1d9740ff2c24ba9fb40b87"
  }.freeze

  config = FormulaHelper::BinaryConfig.new(
    owner: "benbenbang",
    repo: "consilium",
    version: version,
    binary_name: "csl",
    sha256s: SHA256S,
    use_private_repo: true
  )

  FormulaHelper.setup_binary(self, config)

  test do
    assert_match "csl", shell_output("#{bin}/csl --help")
  end
end
```

## Quick Workflow

### Creating a New Binary Formula:
```bash
# 1. Generate template
./scripts/generate_formula.rb binary benbenbang/consilium 2.0.0 csl --private > Formula/csl.rb

# 2. Edit to add description, license, and SHA256s
# 3. Done!
```

### Updating SHA256s:
```bash
# Paste your SHA256s into a file
cat > sha256s.txt <<EOF
csl-darwin-amd64: sha256:abc...
csl-darwin-arm64: sha256:def...
csl-linux-amd64: sha256:ghi...
csl-linux-arm64: sha256:jkl...
EOF

# Update formula
./scripts/update_sha256.rb Formula/csl.rb sha256s.txt
```

### Creating a Source Build Formula:
```bash
# Generate Rust project formula
./scripts/generate_formula.rb source benbenbang/uv-shell 2.0.0 --rust --revision abc123 > Formula/uv-shell.rb

# Generate Go project formula
./scripts/generate_formula.rb source owner/project 1.0.0 --go > Formula/project.rb
```

## Files Created

```
scripts/
├── formula_helper.rb          # Core helper module
├── generate_formula.rb        # Formula generator (executable)
└── update_sha256.rb          # SHA256 updater (executable)

examples/
├── binary_formula_example.rb  # Binary formula examples
└── source_formula_example.rb  # Source build examples

docs/
└── FORMULA_HELPER_GUIDE.md   # Complete documentation
```

## Next Steps

1. **Try it out**: Generate a new formula or convert an existing one
2. **Read the guide**: Check `docs/FORMULA_HELPER_GUIDE.md` for details
3. **Automate**: Consider using the update script in CI/CD

## Benefits

- 🎯 **Less Code**: ~50% reduction in formula size
- 🚀 **Faster Updates**: Update SHA256s with one command
- 🛡️ **Less Error-Prone**: No copy-paste mistakes with if/elsif chains
- 🔄 **Easier Maintenance**: Central helper means fewer places to update
- 📦 **Flexibility**: Supports both binary releases and source builds
- 🤖 **Automation-Ready**: Easy to script and automate

## Questions?

Check the full guide: `docs/FORMULA_HELPER_GUIDE.md`

Happy brewing! 🍺
