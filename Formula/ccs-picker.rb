# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for ccs-picker - Claude Session Picker
class CcsPicker < Formula
  desc "Fast, interactive terminal UI for browsing and resuming Claude sessions"
  homepage "https://github.com/benbenbang/ccs-picker"
  url "https://github.com/benbenbang/ccs-picker/archive/refs/tags/v1.0.0.tar.gz",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  head "https://github.com/benbenbang/ccs-picker.git", branch: "main",
       using: GitHubPrivateRepositoryDownloadStrategy

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  def caveats
    <<~EOS
      To set up shell integration, run:
        ccs-picker --install

      Then reload your shell:
        source ~/.zshrc  # or ~/.bashrc, ~/.config/fish/config.fish

      Usage:
        ccs          # Launch interactive picker
        Ctrl+G       # Keybinding to insert session ID at cursor

      See more options with:
        ccs-picker --help
    EOS
  end

  test do
    # Test that the binary runs and shows help
    assert_match "Interactive Claude session picker", shell_output("#{bin}/ccs-picker --help")
  end
end
