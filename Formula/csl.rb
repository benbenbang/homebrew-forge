# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for csl - Consilium CLI
class Csl < Formula
  desc "Consilium CLI for development workflows"
  homepage "https://github.com/benbenbang/consilium"
  version "1.3.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b323095ed2525379621cfe45d8641aba996ca1d73f74f89168dd5206cc5603d5"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "fdd939f8ef33840e89dffe1fe4ab74f77f3070b2168241165dd1a7ffc04a8259"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e39d548317165091dc71297e6fadb6f5987cc851642b883bbf367a65a58975cb"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "f1e27fc1d703acacaef6537f694476d6653e5aa05f9632b0b1e090899b28f124"
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
