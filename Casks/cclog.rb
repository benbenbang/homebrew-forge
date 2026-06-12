# typed: strict
# frozen_string_literal: true

# Include the custom download strategy for private GitHub release assets
require_relative "../scripts/github_prv_repo_download_strategy"

cask "cclog" do
  version "1.2.0"
  sha256 "180cce1170531f82f547cf1a67c09286766490ff0ab4915d500c9fc7db7afc2f"

  url "https://github.com/benbenbang/cclog/releases/download/#{version}/CCLog_#{version}_universal.dmg",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  name "CCLog"
  desc "Native app for reading Claude Code session logs"
  homepage "https://github.com/benbenbang/cclog"

  depends_on macos: :catalina

  app "CCLog.app"

  zap trash: [
    "~/Library/Application Support/dev.bitbrew.cclog",
    "~/Library/Caches/dev.bitbrew.cclog",
    "~/Library/Preferences/dev.bitbrew.cclog.plist",
    "~/Library/Saved Application State/dev.bitbrew.cclog.savedState",
  ]
end
