# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for cj - jump between useful directories
class Cj < Formula
  desc "Shell companion for jumping between useful directories"
  homepage "https://github.com/bitbrew-dev/cj-rs"
  version "1.0.1"
  license "MIT"
  head "https://github.com/bitbrew-dev/cj-rs.git", branch: "main"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c92b8553725b9576f9d931933f7a25798b6decce941b84100d6f0c2807244823"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "accfe98ec3be36937f2df50e81be3095ccfe98645a108017e9aa22d23ec3ea61"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "b9c7440d704d4aeb4b1c8a0ffd19b76edeb6121ae8749fa6e9b1d676017fa9ff"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "709136cf4face1a9dc83508272bbb674268bf8c5c70950795054625305dd4523"
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
