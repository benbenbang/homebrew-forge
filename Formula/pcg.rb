# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.3.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "7827b90d75a57d55a73d7b9f4f9fb59369079044d4813e5e36a310e84a679cdd"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "1d714a150df1620ea34d65f97a336ccd7910032a647fa9b655143e8beab11730"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "f7313135c78097ff6f615cc5baa9bd2804649dfe4f124eff98f22c075d49a61d"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2ff52f20f657924fe88824460495819e239f1b5a38d8723b74450afd55c18d78"
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
