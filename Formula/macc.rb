# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
# Once bitbrew-dev/macc is public, drop this require and the `using:` lines below
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for macc - Multi-Agent Communication Center
class Macc < Formula
  desc "Multi-Agent Communication Center server, watcher and migrations"
  homepage "https://github.com/bitbrew-dev/macc"
  version "0.11.0"
  license "Elastic-2.0"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_darwin_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "f799d6a628913f807fb44ae75afb3fcae6f9e3b9941515dccd51ead69dbb11fe"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_darwin_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "d7276cf0bf8f44c1a9c10a3a52e1b1c77419b282e40afc3cb7241a47ed64f510"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "86cbae416be05800de062c06057d5fbe3b7cc647268329042d4f2ecbdd6001fa"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/macc/releases/download/v#{version}/macc_v#{version}_linux_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "75ea37c2ca635d36c81beba15e4f91301da4ae97f0dc65f4085f09213a39ff3e"
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
