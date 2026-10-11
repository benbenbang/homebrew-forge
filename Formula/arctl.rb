# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for areo - arctl cli
class Arctl < Formula
  desc "Arctl manage the complete lifecycle of the Airflow Helm deployment on a local k3d cluster"
  homepage "https://github.com/benbenbang/areo"
  version "2.3.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e9c255ef3b065f9e142cbb5a6102044bb0fc9d03d754756c4864f89096af8855"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "fa5fb999c815810a81c6e3d8817e394ce59f24376b0adda35ef2b4ee6d273084"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2d6979c56c892ca2095f6c97dcb2f74799bce8084eaadee4030b1f0cf5acae3a"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4636d74cc9b7d902e38ddf069f73882b4f8589b84969748511d1905049549179"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "arctl"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "arctl", shell_output("#{bin}/arctl --help")
  end
end
