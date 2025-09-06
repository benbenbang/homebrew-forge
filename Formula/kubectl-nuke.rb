# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for kubectl-nuke - Delete Kubernetes resources with filtering options
class KubectlNuke < Formula
  desc "Delete Kubernetes resources with filtering options"
  homepage "https://github.com/benbenbang/kute"
  version "1.1.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-nuke-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "82baa46c3b19626949576fe103911a39016809a5a3849d9a937bbf0b245f3bf1"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-nuke-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b2664bd89abc7337f19271e71e7064047c24599125e4cda1e191de9a18a322ad"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-nuke-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "23c94c990939b0d006f4758d4a112e5e09601ea81f806ea3757b553918e753b1"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-nuke-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "0f3a4a1230fed62d74316910ccd8100a2a3499b52c2d8d627ffdbbd8e1bb8435"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "kubectl-nuke"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "kubectl-nuke", shell_output("#{bin}/kubectl-nuke --help")
  end
end
