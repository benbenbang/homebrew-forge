# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for csl - Consilium CLI
class Csl < Formula
  desc "Consilium CLI for development workflows"
  homepage "https://github.com/benbenbang/consilium"
  version "1.4.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "02bde449b38bb76fb8ad3f6a31531f110db18f86ec72f44a112535b6e970bf05"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "bef3b3e4e6d8bc0483eb1d90f50480558373c15e74f1e9d4119cdfeef5f6d64c"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "900ebb33a2b3f43e2fb146ec9b46bd3c67559c9180bbe78b72e6cd2c4360ecbf"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "065b5ea004abb18a4a89f42db51edde195b1bcf6feda7ddf0d39e35bcd82d771"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "csl"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "csl", shell_output("#{bin}/csl --help")
  end
end
