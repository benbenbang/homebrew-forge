# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for kubectl-obj-transform - Transform Kubernetes secrets or configmaps to .env format
class KubectlObjTransform < Formula
  desc "Transform Kubernetes secrets or configmaps to .env format"
  homepage "https://github.com/benbenbang/kute"
  version "1.1.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-obj_transform-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "5a809255435d2d9857c03527aa722d274591ad956354796879ba2a1e955a0506"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-obj_transform-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "6bb82b6d6695dca9b637fa574e37ad81071e6c3482f2342a3c46c47eb4b809c2"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-obj_transform-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "5fb5fbb2660c05e8f80bad80374d0e4aec41ed61eec147680c4504b66f3231e0"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/kute/releases/download/#{version}/kubectl-obj_transform-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "d38a6b543e949a2ec3376a45c1858cd2a04eb14be9c125e331a7f5f2f0387034"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "kubectl-obj-transform"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "kubectl-obj-transform", shell_output("#{bin}/kubectl-obj-transform --help")
  end
end
