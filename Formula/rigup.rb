# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for rigup (installs the rig binary) - Project configuration generator
class Rigup < Formula
  desc "Project configuration generator for development workflows"
  homepage "https://github.com/benbenbang/rigup"
  version "3.0.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/rigup/releases/download/v#{version}/rig-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "9f6d85a9ebb82ebc0ab34866226b6670b14dd09281638dd72c0a5ce5ec6419ce"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/rigup/releases/download/v#{version}/rig-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "ba6eaaa092b5f7790e549cde54f23742ff8264ed9ca0e00c8d45a416788a97f6"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/rigup/releases/download/v#{version}/rig-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b90a9ff85c872c8f93dba8a1398b7b513058dde41dcf4f59f43acc9dbb91988b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/rigup/releases/download/v#{version}/rig-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "80d2dd787919d26fe6bc4c09ab72a8a1713cbbc6dd9f19d366f55e9aa9bb647b"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "rig"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "rig", shell_output("#{bin}/rig --help")
  end
end
