# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for cj - jump between useful directories
class Cj < Formula
  desc "Shell companion for jumping between useful directories"
  homepage "https://github.com/bitbrew-dev/cj-rs"
  version "0.3.0"
  license "MIT"
  head "https://github.com/bitbrew-dev/cj-rs.git", branch: "main"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c3d1db2db6313bdd8434c2269b50ae176abc3e9ba6a4ae465e6d1d3f1ccdc148"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-apple-darwin.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4fc834e1dd8fe68cf672fb84c17adad969c9befbe3c301e24aadb584895bf1dc"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-aarch64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c975358f56d64aa84cd8f72e77933a9d69a289ffb3b721f7f4a5eed9923fd4a0"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/cj-rs/releases/download/#{version}/cj-rs-#{version}-x86_64-unknown-linux-gnu.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "e5cf93e87383d24b1cd1b82d0df22fd23fb4bee1569f2066a6286af2629e0dde"
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
