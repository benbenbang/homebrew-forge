# typed: strict
# frozen_string_literal: true

# Example: macOS app cask distributing a .dmg from a GitHub release.
#
# Casks (in Casks/) distribute pre-built macOS artifacts — .dmg/.pkg/.zip — as
# opposed to formulae (in Formula/), which build/install CLI tools. A tap can host
# both at once. Install with:  brew install --cask benbenbang/forge/<name>
#
# Keep the version out of the filename by interpolating #{version} in the url; that
# way `cask.rb -v <new>` only has to touch the `version` and `sha256` lines.

# --- Private repo: reuse the tap's GitHub token download strategy --------------
# Drop this require line for a PUBLIC repo (no auth needed) and Homebrew downloads
# the release asset directly.
require_relative "../scripts/github_prv_repo_download_strategy"

cask "example-app" do
  version "1.0.0"
  sha256 "0" * 64 # sha256 of the .dmg — `cask.rb` fills this from the release asset

  url "https://github.com/owner/repo/releases/download/#{version}/ExampleApp_#{version}_universal.dmg",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy # omit `using:` for public repos
  name "Example App"
  desc "One-line description without the word macOS" # `desc` may not contain the platform
  homepage "https://github.com/owner/repo"

  depends_on macos: :catalina # minimum macOS (oldest symbol Homebrew still accepts)

  app "Example App.app" # the .app bundle inside the mounted DMG

  # Clean up app-managed files on `brew uninstall --zap`. Use the app's bundle id.
  zap trash: [
    "~/Library/Application Support/com.example.app",
    "~/Library/Caches/com.example.app",
    "~/Library/Preferences/com.example.app.plist",
    "~/Library/Saved Application State/com.example.app.savedState",
  ]
end

# --- Arch-split variant (when there's no universal build) ----------------------
# Replace the single url/sha256 above with per-arch blocks; `cask.rb` pairs each
# url to its nearest sha256, so both checksums update correctly:
#
#   on_arm do
#     sha256 "..."
#     url ".../ExampleApp_#{version}_aarch64.dmg", using: GitHubPrivateRepositoryReleaseDownloadStrategy
#   end
#   on_intel do
#     sha256 "..."
#     url ".../ExampleApp_#{version}_x86_64.dmg", using: GitHubPrivateRepositoryReleaseDownloadStrategy
#   end
