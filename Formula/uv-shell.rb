# typed: strict
# frozen_string_literal: true

# Formula for uv-shell
class UvShell < Formula
  desc "Create and activate Python virtual environments with uv"
  homepage "https://github.com/benbenbang/uv-shell"
  url "https://github.com/benbenbang/uv-shell.git",
      tag:      "2.0.0",
      revision: "d4ebe7d32f9dffe8a2cd5eb2fa789a44d98222a3"
  license "MIT"
  head "https://github.com/benbenbang/uv-shell.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "uv-shell"
  end

  def caveats
    <<~EOS
      To enable auto-activation of .venv directories, add to your shell config:

      Bash/Zsh (~/.bashrc or ~/.zshrc):
        eval "$(uv-shell anchor)"

      Fish (~/.config/fish/config.fish):
        uv-shell anchor --shell fish | source

      PowerShell ($PROFILE):
        Invoke-Expression (& uv-shell anchor --shell powershell)

      Nushell (~/.config/nushell/config.nu):
        use (uv-shell anchor --shell nushell)

      Install completions:
        uv-shell completions <bash|zsh|fish|nushell|powershell>

      Usage:
        uv-shell              # Create .venv and activate in new shell
        uv-shell --help       # Show all available options
    EOS
  end

  test do
    # Test that the binary runs and shows help
    assert_match "Create and activate a Python virtual environment", shell_output("#{bin}/uv-shell --help")
  end
end
