# typed: strict
# frozen_string_literal: true

# Include the custom download strategy for private GitHub release assets
require_relative "../scripts/github_prv_repo_download_strategy"

cask "cclog" do
  version "1.3.0"
  sha256 "d4d56360492ada4e2b82bfa521d6feaba7e2298f628924d4c0be758e673bf629"

  url "https://github.com/benbenbang/cclog/releases/download/#{version}/CCLog_#{version}_universal.dmg",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  name "CCLog"
  desc "Native app for reading Claude Code session logs"
  homepage "https://github.com/benbenbang/cclog"

  depends_on macos: :catalina

  app "CCLog.app"

  uninstall quit: "dev.bitbrew.cclog"

  zap trash: [
    "~/Library/Application Support/dev.bitbrew.cclog",
    "~/Library/Caches/dev.bitbrew.cclog",
    "~/Library/Preferences/dev.bitbrew.cclog.plist",
    "~/Library/Saved Application State/dev.bitbrew.cclog.savedState",
  ]
end
