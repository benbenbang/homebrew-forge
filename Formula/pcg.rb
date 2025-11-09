# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for pcg - Project configuration generator
class Pcg < Formula
  desc "Project configuration generator for development workflows"
  homepage "https://github.com/benbenbang/prjconf-cli"
  version "1.5.2"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "a769d0bca078dd1a93636fe72d673b6a565e4b2703f4966296a96a0f9801921b"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "560ca421c619e323e7a5f31a51b8f06447cdf1734088d6ed670ebb71b41b102e"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "8e721b72667e813b3861ad3c0183e6e6311ed52a0103f0c619fd6cfbbd80e911"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/prjconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4c588de017032676fbb28f165eca9e5452ff7d57a7183dd662641b7584b34585"
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
