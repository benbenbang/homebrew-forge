# typed: strict
# frozen_string_literal: true

# Homebrew cask for the Claude Island app (github.com/benbenbang/claude-island).
#
# Token is "claudeisland" (NOT "claude-island"): "claude-island" is the upstream
# project's OLD name in homebrew/cask and now redirects to the `vibe-notch` cask,
# so a bare `brew install claude-island` would install Vibe Notch instead.
#
# 1.5.0: Sparkle is disabled (empty SUFeedURL, auto-checks off), so it no longer
# self-updates to Vibe Notch. NOTE: the bundle id in this build is still
# com.celestial.ClaudeIsland (the dev.bitbrew.claudeisland rename has NOT shipped
# yet), so the uninstall/zap ids below must match com.celestial. Update them to
# dev.bitbrew.claudeisland only once a release actually carries that id.
cask "claudeisland" do
  version "1.5.0"
  sha256 "74ccd5288786155687a4840c6bb39813a775a89b9a433f54f4afb39c5de27a4a"

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
