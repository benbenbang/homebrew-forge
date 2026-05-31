# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Project configuration generator
class Pcg < Formula
  desc "Project configuration generator for development workflows"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.10.1"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "52f0187361dc2743a8c80340f07f5ac5ac6ad80276461d622cd9f11de9c61123"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "9033c1a28efc851f2fd87269fed0830c9be78e6332094606237949988be51100"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4d7e9bd7e6a014fca838b21e2ce30aa8f3b22d2c3187f17b19379afabea51b45"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "38f7be3270ca71838a9b66ba7cf96617383c6b66528d88b1a82ba11a391bee9c"
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
