# typed: strict
# frozen_string_literal: true

# Formula for claude-island app dmg
cask "claude-island" do
  version "1.4.0"
  sha256 "e88bdd2296c54598c3b3aa263005d223a6e8459d"

  url "https://github.com/benbenbang/claude-island/releases/download/#{version}/ClaudeIsland-#{version}.dmg",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  name "ClaudeIsland"
  desc "Native app for using notch like dynamic island to read, approve, etc the permissions"
  homepage "https://github.com/benbenbang/claude-island"

  depends_on macos: :catalina

  app "ClaudeIsland.app"

  uninstall quit: "dev.bitbrew.claude-island"

  zap trash: [
    "~/Library/Application Support/dev.bitbrew.claude-island",
    "~/Library/Caches/dev.bitbrew.claude-island",
    "~/Library/Preferences/dev.bitbrew.claude-island.plist",
    "~/Library/Saved Application State/dev.bitbrew.claude-island.savedState",
  ]
end
