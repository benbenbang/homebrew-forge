# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for csl - Consilium CLI
class Csl < Formula
  desc "Consilium CLI for development workflows"
  homepage "https://github.com/benbenbang/consilium"
  version "1.10.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "5a77e4231305a16cd0df8f2734238ca091f702f5b0f2b81c6e9478624e2c23ad"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "136f2a23497c90a2f747cc3f6c68c0d4f7933b6fe483e1c55f71d4df6f01577e"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "da46b8224333f7b90df2986c0797a5a19dbf69647114933c972e5850307992ba"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "a2b76c3dd5069bff60d53d869df9b30f289acbfd6ec84e92234c6ac1de29101d"
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
