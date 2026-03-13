# typed: strict
# frozen_string_literal: true

# Formula for uv-shell
class UvShell < Formula
  desc "Create and activate Python virtual environments with uv"
  homepage "https://github.com/benbenbang/uv-shell"
  url "https://github.com/benbenbang/uv-shell.git",
      tag:      "2.1.0",
      revision: "f6e3307c24564b1e1aa2913e280fcae15c8d49c3"
  license "MIT"
  head "https://github.com/benbenbang/uv-shell.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Main uv-shell binary
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # uv plugin wrapper — installed to libexec to avoid conflict with real uv
    system "cargo", "install", "--locked", "--root", libexec, "--path", "adds-on"
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

      --- uv plugin wrapper ---
      To enable `uv shell` and plugin-aware completions, prepend the wrapper to PATH:

        export PATH="#{opt_libexec}/bin:$PATH"
        export UV_REAL_PATH="$(which uv)"  # optional: skip PATH scan on every uv call

      Then reload completions (once, or add to shell rc):

        # zsh
        unfunction _uv _uv_commands 2>/dev/null
        eval "$(uv generate-shell-completion zsh)"

        # bash
        eval "$(uv generate-shell-completion bash)"

        # fish
        uv generate-shell-completion fish | source
    EOS
  end

  test do
    assert_match "Create and activate a Python virtual environment", shell_output("#{bin}/uv-shell --help")
    assert_predicate libexec/"bin/uv", :executable?
  end
end
