# typed: strict
# frozen_string_literal: true

require_relative "../scripts/formula_helper"

# Example: Binary release formula using FormulaHelper
# This shows how much simpler formulas can be with the helper
class ExampleBinary < Formula
  desc "Example binary release formula"
  homepage "https://github.com/owner/repo"
  version "1.0.0"
  license "MIT"

  # Define configuration
  config = FormulaHelper::BinaryConfig.new(
    owner: "owner",
    repo: "repo",
    version: version,
    binary_name: "example",
    sha256s: {
      "darwin-arm64" => "sha256_here",
      "darwin-amd64" => "sha256_here",
      "linux-arm64" => "sha256_here",
      "linux-amd64" => "sha256_here"
    },
    use_private_repo: false # Set to true if using private repo
  )

  # Setup the formula
  FormulaHelper.setup_binary(self, config)

  test do
    assert_match "example", shell_output("#{bin}/example --help")
  end
end

# Alternative: For simpler updates, you can pass SHA256s from a hash
# This makes it easier to update via script
SHA256S = {
  "darwin-arm64" => "new_sha256",
  "darwin-amd64" => "new_sha256",
  "linux-arm64" => "new_sha256",
  "linux-amd64" => "new_sha256"
}.freeze
