# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for cj - jump between useful directories
class Cj < Formula
  desc "Shell companion for jumping between useful directories"
  homepage "https://github.com/bitbrew-dev/cj-rs"
  version "0.4.0"
  license "MIT"
  head "https://github.com/bitbrew-dev/cj-rs.git", branch: "main"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "08db22b93a7fd25347d978e76387ad09911b4a98560ae05b529c08f1cabbdf12"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "3c25d126c273a1bdaedcbf3ce147a7ef340c01e47a1d9c3e71bfa8c93f824248"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e1f728ebae56c12339fdc75b64d3b16e838e8385e7fcb6d93e6191315802cfc2"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "27074231de08a8c3bb97dc142e2abe9ff3457fedb7d6f083d2c815ef8f6b456a"
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
