# typed: strict
# frozen_string_literal: true

# Include the custom download strategy for private GitHub release assets.
# On `brew upgrade`, Homebrew copies this cask file alone into the Caskroom
# receipt (without the sibling scripts/ dir) and loads it to run the old
# version's uninstall — so require_relative fails there with a LoadError.
# Fall back to a stub so the receipt still loads: uninstall never downloads,
# it only quits and removes the app.
begin
  require_relative "../scripts/github_prv_repo_download_strategy"
rescue LoadError
  require "download_strategy"
  unless defined?(GitHubPrivateRepositoryReleaseDownloadStrategy)
    GitHubPrivateRepositoryReleaseDownloadStrategy = Class.new(CurlDownloadStrategy)
  end
end

cask "cclog" do
  version "1.4.0"
  sha256 "e4c2c8d38e200e293d4abf077fdda80438fd177c219ad8898813c18d39e1a470"

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
