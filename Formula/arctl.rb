# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for areo - arctl cli
class Arctl < Formula
  desc "Arctl manage the complete lifecycle of the Airflow Helm deployment on a local k3d cluster"
  homepage "https://github.com/benbenbang/areo"
  version "2.4.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "ca4f229d9f54d98be1d55b1c71b424c76db0809b4a29b63e5158b7add89bfbc5"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "a023854837335eb1f64bddb85f284d280fe7f8f3402c3e31151de551977d983c"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "cd4f4c65281a1f9a1159ad02540a6f9c7a8bf161c3f3acb349ce6c0bb92cda5b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/areo/releases/download/#{version}/arctl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "a92ab164df6dfb30baf127337746a43c683dc0cf51db83acd8d33c1c70c4fb0e"
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
