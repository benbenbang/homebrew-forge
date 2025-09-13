# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.3.1"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "106b678ae8bb8b761923ac5ceae6fd9110c46e602bf1c0f0a929e372e441ee18"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "246350205f98b6ba8f2e375cb7a0b3be03e4496418a17c71434f9a70e725e3c0"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "79a05ef377d919641d24078c3b3ac257716803fd81797bbef3b105ba4a037bba"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "35c0e0bb60cadad0e9465e8caea6bbb04495baa6107d397dc61b92f28614a260"
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
