# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for csl - Consilium CLI
class Csl < Formula
  desc "Consilium CLI for development workflows"
  homepage "https://github.com/benbenbang/consilium"
  version "1.12.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "694c84a825a22a96c5e0abb24053477eb50308b1a402e2f96ca55fb5365f5800"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c3e28ac9110a369cc5836c702b25062b898eb09a08b27fee942c6bd54cf7440b"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "3df510c93b4e8680371b7728ff51657c7ce9fe237dde081fea5acb66fa5dd12b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c9ac1b0cb0524f9cbac0bf448806eb7082d7c83c489272b2f8896948abdebda2"
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
