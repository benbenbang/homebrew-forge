# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Project configuration generator
class Pcg < Formula
  desc "Project configuration generator for development workflows"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.4.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "06e7101f6c213af85507ce6ac8a44953821a735ba8a56eb995614be33fbd9517"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "be7f652970fc1b86df64b7fd74df846af22483854b8d35ac3e756018ca35072f"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "6a27c2e906cc588a47d8036547fc30c46306fb2945a21b7527ba5588e3bf318b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "adc4c3c91204187312fa923fc0242b460ae4280d4a3163aa86d91c5e8f87fe12"
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
