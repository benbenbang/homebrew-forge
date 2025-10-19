# typed: strict
# frozen_string_literal: true

# Formula for ccs-picker - Claude Session Picker
class CcsPicker < Formula
  desc "Fast, interactive terminal UI for browsing and resuming Claude sessions"
  homepage "https://github.com/benbenbang/ccs-picker"
  url "https://github.com/benbenbang/ccs-picker.git",
      tag:      "1.1.3",
      revision: "67998a43c1d0f966aca6eafb02b65954aa274211"
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
