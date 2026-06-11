# typed: strict
# frozen_string_literal: true

# Include the custom download strategy for private GitHub release assets
require_relative "../scripts/github_prv_repo_download_strategy"

cask "cclog" do
  version "1.0.0"
  sha256 "4dd550b3af28975d5598a3ce6fd6c2f64d0bb92e1cdd69cdaa74ebc7ce81cb68"

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
