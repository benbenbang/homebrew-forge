# typed: strict
# frozen_string_literal: true

# Formula for uv-shell
class UvShell < Formula
  desc "Create and activate Python virtual environments with uv"
  homepage "https://github.com/benbenbang/uv-shell"
  url "https://github.com/benbenbang/uv-shell.git",
      tag:      "2.3.0",
      revision: "d91b44617a29589244a0456981d93f90a277049e"
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
      To enable `uv shell` and plugin-aware completions:

      1. Add to your shell rc (~/.zshrc or ~/.bashrc):
           export PATH="#{opt_libexec}/bin:$PATH"

      2. Install completions once:
           # zsh — auto-loaded every session, plugins discovered dynamically
           uv generate-shell-completion zsh > "${fpath[1]}/_uv"

           # nushell — add to config.nu: use ~/.config/nushell/completions/uv.nu
           uv generate-shell-completion nushell | save ~/.config/nushell/completions/uv.nu

           # bash
           echo 'eval "$(uv generate-shell-completion bash)"' >> ~/.bashrc

           # fish
           uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish

      zsh: new plugins are discovered dynamically at tab-press time — no reload needed.
      nushell/bash/fish: re-run the above command after installing new plugins.
    EOS
  end

  test do
    assert_match "Create and activate a Python virtual environment", shell_output("#{bin}/uv-shell --help")
    assert_predicate libexec/"bin/uv", :executable?
  end
end
