# typed: strict
# frozen_string_literal: true

# Include the custom download strategy for private GitHub release assets
require_relative "../scripts/github_prv_repo_download_strategy"

cask "cclog" do
  version "1.1.0"
  sha256 "867ac41c958367dc25805794a31eb7e9513c4420222159d20d3896d4c109e1f0"

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
