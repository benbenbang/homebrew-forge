# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for ccs-picker - Claude Session Picker
class CcsPicker < Formula
  desc "Fast, interactive terminal UI for browsing and resuming Claude sessions"
  homepage "https://github.com/benbenbang/ccs-picker"
  url "https://github.com/benbenbang/ccs-picker.git",
      tag:      "1.7.0",
      revision: "c972c1180482c63ddaeab2b2ae39e9434e2c2e1e"
  license "MIT"
  head "https://github.com/benbenbang/ccs-picker.git", branch: "main"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/benbenbang/ccs-picker/releases/download/#{version}/ccs-picker-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "7bbba8b0a284487b8b0a52f99a6d75ae66f8fab00c39ef467525fe705d92ee83"
    else
      url "https://github.com/benbenbang/ccs-picker/releases/download/#{version}/ccs-picker-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "de1b7d2fcd1fde38bc00de0b910a2f1b30260c43273b775567912e3ffa8c90bb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/benbenbang/ccs-picker/releases/download/#{version}/ccs-picker-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aa962a3bff68e35245a0c31b6e908881ef251da4d4316f49bf282d042ba849b1"
    else
      url "https://github.com/benbenbang/ccs-picker/releases/download/#{version}/ccs-picker-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "050347d4a4bfd72dfd39dfb5992c9a7510b4e7fabfcc5c0a035ea11880243841"
    end
  end

  def install
    bin.install "ccs-picker"
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
