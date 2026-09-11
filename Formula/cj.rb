# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for cj - jump between useful directories
class Cj < Formula
  desc "Shell companion for jumping between useful directories"
  homepage "https://github.com/bitbrew-dev/cj-rs"
  version "1.0.0"
  license "MIT"
  head "https://github.com/bitbrew-dev/cj-rs.git", branch: "main"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "70bd6904d2d290934779e78a1df09c57192aa1f73fbc1d8125abdc78f18710ca"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e372b00e7679cef5c6b3e25bb70acc2e3095174186092bd160667630e8dd6811"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b328d55235dd6df54b362c6cc84f0202e275376b78cda63cdf5666b3c44f240e"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "51c2303da8861f16e4792a7dc3bb1bd2ed816c0eaa5045bd7ca5f193a8707733"
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
