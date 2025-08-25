# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.2.1"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "11b5789e6a93972889b1f4f2604986cd0e1674de5432ce8358747b8bb29944c7"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "913beef150aec5b55d7cd1bbb7273084aa6eda42a22cb9289f0bad98ad635555"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "069e8b37061b7468304316c842fe6f54acf82d117229a1bc5d90105c3ccf31a3"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "45acdf2be5654694d196ec294683386317c0300e26963c65648048491c6b856d"
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
