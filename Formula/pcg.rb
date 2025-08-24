# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.2.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "51e03a0cd61d8e38fd430fbd6fbaa9853d92eadbd675e2b551722eca53105fbf"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "10c46d1bd255c42edb52bb7d98055d24d9f0ea7d5b9887c555d6234ee6d533f7"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c034c5dc516f130ec9cdd930908d34738d92f4ca171d6134087db56bcae513e5"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "f349085bffc91d0e847b7951c3d2e9faff1afb624a2b6b23893430298132d238"
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
