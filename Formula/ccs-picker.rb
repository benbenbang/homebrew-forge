# typed: strict
# frozen_string_literal: true

# Formula for ccs-picker - Claude Session Picker
class CcsPicker < Formula
  desc "Fast, interactive terminal UI for browsing and resuming Claude sessions"
  homepage "https://github.com/benbenbang/ccs-picker"
  url "https://github.com/benbenbang/ccs-picker.git",
      tag:      "1.5.1",
      revision: "2e6b9651a4e3f3dae08b2b5b642cb3b2da1e238c"
  license "MIT"
  head "https://github.com/benbenbang/ccs-picker.git", branch: "main"

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
