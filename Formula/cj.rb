# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for cj - jump between useful directories
class Cj < Formula
  desc "Shell companion for jumping between useful directories"
  homepage "https://github.com/bitbrew-dev/cj-rs"
  version "0.2.0"
  license "MIT"
  head "https://github.com/bitbrew-dev/cj-rs.git", branch: "main"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "09a4bd7c7d2a7f6e470879d692ce4ad50659fe42075f72791c77533686e3c944"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "d0a024accc5585c70776ccdf0bbf1e0e4e850f7fb760f23ed0f15078aab03701"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "ce426fb4c16cc4898585648fe6ee9a61ca39b85b8b838145168b8ad74657b01f"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e53e237b3e2c5b311f5cdbaa0d728abad56fda53760e8f15074a4e261c704ed6"
  end

  def install
    bin.install "cj"
  end

  def caveats
    <<~EOS
      cj needs shell integration to change your current directory. Generate the
      init and completion scripts for your shell, then source them.

      Zsh (~/.zshrc):
        mkdir -p ~/.config/cj
        cj init zsh > ~/.config/cj/init.zsh
        cj completions zsh > ~/.config/cj/completions.zsh
        # then add to ~/.zshrc:
        source ~/.config/cj/init.zsh
        source ~/.config/cj/completions.zsh

      Bash, Nushell, and PowerShell are also supported: replace "zsh" with
      bash, nu, or powershell.

      See more options with:
        cj --help
    EOS
  end

  test do
    # Test that the binary runs and shows help
    assert_match "jump between useful directories", shell_output("#{bin}/cj --help")
  end
end
