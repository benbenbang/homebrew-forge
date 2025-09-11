# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for git-worktree - Git worktree utils
class GitWorktree < Formula
  desc "Enhanced git worktree utilities for managing multiple working trees"
  homepage "https://github.com/benbenbang/git-worktree"
  version "1.0.1"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/git-worktree/releases/download/#{version}/git-wt-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "52713b7454f58e9b85112c99a5c7ec0a0d218f0cc8065861baca244dacbb60e6"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/git-worktree/releases/download/#{version}/git-wt-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "fb51d3485018c9cf81208fbf37f557cd67ed2da68544c2465a9a9919408aa7bd"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/git-worktree/releases/download/#{version}/git-wt-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "8a81ebc1a30af714f503ee1ef6d6fc81dbb837d0fb1df262fdb2da08f5f51721"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/git-worktree/releases/download/#{version}/git-wt-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "bcaf95bd09760e2f1a46a3f9c2ed1ee824dfbd2cd35458647b8006991ada9d2f"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "git-wt"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "git-wt", shell_output("#{bin}/git-wt --help")
  end
end
