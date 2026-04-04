# typed: strict
# frozen_string_literal: true

# Formula for typora-cli
class TyporaCli < Formula
  desc "Minimal CLI wrapper to open files in Typora from the terminal"
  homepage "https://github.com/benbenbang/typora-cli"
  url "https://github.com/benbenbang/typora-cli.git",
      tag:      "1.0.0",
      revision: "5c09a297db7cfe19964d01c9c3d1357a52361f8e"
  license "MIT"
  head "https://github.com/benbenbang/typora-cli.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    mv bin/"typora-cli", bin/"tyc"
  end

  def caveats
    <<~EOS
      typora-cli lets you open files in Typora without leaving the terminal.
      The file is created automatically if it does not exist.

      Usage:
        typora-cli                   # open current directory in Typora
        typora-cli notes.md          # open (or create) notes.md
        typora-cli docs/readme.md    # missing parent dirs are created automatically
        typora-cli ../relative.md    # relative paths work too

      Platform notes:
        macOS   — Typora is launched via `open -a typora`. No PATH setup needed.
        Linux   — `typora` must be on your PATH.
        Windows — `typora` must be on your PATH.
    EOS
  end

  test do
    # Sentinel: opening "." should exit 0 without launching Typora
    system bin/"tyc", "--dry-run", "."

    # File creation: a new file should appear on disk
    test_file = testpath/"test-note.md"
    system bin/"tyc", "--dry-run", test_file.to_s
    assert_predicate test_file, :exist?
  end
end
