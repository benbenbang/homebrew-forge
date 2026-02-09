# typed: strict
# frozen_string_literal: true

require_relative "../scripts/formula_helper"

# Example 1: Rust project building from source
class ExampleRust < Formula
  desc "Example Rust project built from source"
  homepage "https://github.com/owner/rust-project"
  version "1.0.0"
  license "MIT"

  config = FormulaHelper::SourceConfig.new(
    owner: "owner",
    repo: "rust-project",
    version: version,
    revision: "abc123def456", # Optional: git commit SHA
    build_system: :cargo
  )

  FormulaHelper.setup_source(self, config)

  test do
    assert_match "version", shell_output("#{bin}/rust-project --version")
  end
end

# Example 2: Go project building from source
class ExampleGo < Formula
  desc "Example Go project built from source"
  homepage "https://github.com/owner/go-project"
  version "2.0.0"
  license "Apache-2.0"

  config = FormulaHelper::SourceConfig.new(
    owner: "owner",
    repo: "go-project",
    version: version,
    build_system: :go
  )

  FormulaHelper.setup_source(self, config)

  test do
    assert_match "go-project", shell_output("#{bin}/go-project --help")
  end
end

# Example 3: Custom build process
class ExampleCustom < Formula
  desc "Example with custom build process"
  homepage "https://github.com/owner/custom-project"
  version "1.5.0"
  license "MIT"

  config = FormulaHelper::SourceConfig.new(
    owner: "owner",
    repo: "custom-project",
    version: version,
    revision: "deadbeef",
    build_system: :custom,
    build_deps: ["cmake", "pkg-config"],
    install_block: proc do
      # Custom install logic
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make"
        system "make", "install"
      end
    end
  )

  FormulaHelper.setup_source(self, config)

  test do
    system "#{bin}/custom-project", "--version"
  end
end
