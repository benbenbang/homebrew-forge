# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
# Once bitbrew-dev/macc is public, drop this require and the `using:` lines below
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for macc - Multi-Agent Communication Center
class Macc < Formula
  desc "Multi-Agent Communication Center server, watcher and migrations"
  homepage "https://github.com/bitbrew-dev/macc"
  version "0.12.0"
  license "Elastic-2.0"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_darwin_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "518f36cd7bc05e8a7431e75e5e4deefe7b4bc89ca209bb443dd0ea45e17fa4be"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_darwin_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4ef15f38f8a7e4ebf4e964c698730f8afbae1c9776b5d67c272c220264a1e818"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "af993d19bfb16b2e456b0f102074e1feac60f7c90fee4516ca6860647b01f1a0"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_linux_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "72009ace0e28eae6448e3f9392b8991ca8331d6e8bc68cada839323c68028ae0"
  end

  def install
    bin.install "macc", "macc-watch", "macc-migrate"
  end

  test do
    # Test that each binary runs and reports its version or help
    assert_match "Version: v#{version}", shell_output("#{bin}/macc --version 2>&1")
    assert_match "agent id to watch", shell_output("#{bin}/macc-watch --help 2>&1")
    assert_match "schema migrations", shell_output("#{bin}/macc-migrate --help 2>&1")
  end
end
