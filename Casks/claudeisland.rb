# typed: strict
# frozen_string_literal: true

# Homebrew cask for the Claude Island app (github.com/benbenbang/claude-island).
#
# Token is "claudeisland" (NOT "claude-island"): "claude-island" is the upstream
# project's OLD name in homebrew/cask and now redirects to the `vibe-notch` cask,
# so a bare `brew install claude-island` would install Vibe Notch instead.
#
# TODO after cutting the Sparkle-disabled release:
#   - bump `version` + `sha256` to that release
#   - note: release 1.4.1 is a PRE-FIX build (bundle id com.celestial.ClaudeIsland,
#     Sparkle feed still points at the upstream VibeNotch appcast, so it will
#     self-update to Vibe Notch). The uninstall/zap ids below already target the
#     fixed build's id (dev.bitbrew.claudeisland).
cask "claudeisland" do
  version "1.5.0"
  sha256 "5ac783373cc43274d8fd0457a9cd57ea98040946"

  url "https://github.com/benbenbang/claude-island/releases/download/#{version}/ClaudeIsland-#{version}.dmg"
  name "Claude Island"
  desc "Uses the notch like a dynamic island to read and approve Claude Code permissions"
  homepage "https://github.com/benbenbang/claude-island"

  depends_on macos: :sequoia

  app "Claude Island.app"

  uninstall quit: "dev.bitbrew.claudeisland"

  zap trash: [
    "~/Library/Application Support/dev.bitbrew.claudeisland",
    "~/Library/Caches/dev.bitbrew.claudeisland",
    "~/Library/Preferences/dev.bitbrew.claudeisland.plist",
    "~/Library/Saved Application State/dev.bitbrew.claudeisland.savedState",
  ]
end
