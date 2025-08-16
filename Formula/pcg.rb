# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.1.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "137acfd12d6aeb3222ba1fbdb600a326b6180f62e60bc4132a11eeb03e5ec841"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b9a3aad7befc4d7b95f5aa2dc616744138ce150276805e9ff0cda9c623ee1c2b"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "55368d16f898149118f8010723dd8f48cc482311b5a7da439528754341c47778"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "93895408901abffc3c105e66cb3d98941f17d885f32b086420d4d0ce0fb92c47"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "pcg"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "pcg", shell_output("#{bin}/pcg --help")
  end
end
