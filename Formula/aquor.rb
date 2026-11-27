# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for aquor - Quantitative finance toolkit: the qtx CLI and the aquor-api server
class Aquor < Formula
  desc "Quant finance toolkit with qtx CLI and aquor-api server"
  homepage "https://github.com/bitbrew-dev/aquor"
  version "1.23.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy.
  # The main download is the qtx CLI; aquor-api ships as a separate archive.
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/qtx_#{version}_darwin_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "4519d7698a7a24163459e20029c8c36a80180eeae41018846bdd2e74d137a332"

    resource "aquor-api" do
      version "1.23.0"
      url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/aquor-api_#{version}_darwin_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "f901cb6010e028e7cb1226c6cee33a12df69374cb4bc203b4ed97d50faef3d80"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/qtx_#{version}_darwin_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2a53ad257f4ae654708f640aef20d2ca62cbb19b580c655cb0415bf8229eb65c"

    resource "aquor-api" do
      version "1.23.0"
      url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/aquor-api_#{version}_darwin_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "755dca4ea381fc13842e89823b5af4bf20d601f76a0044cab51bea618999fccc"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/qtx_#{version}_linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c5cdbe370d1d363961ae094bfa5e6b1dbad94b82636e0681af68575894666f2c"

    resource "aquor-api" do
      version "1.23.0"
      url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/aquor-api_#{version}_linux_arm64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "d46ce11444e066462343781bce4d7af251fdabef64af4a4f86121dc9f2d2007f"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/qtx_#{version}_linux_amd64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "8033f971c7a007b573944d8a4c6ed7af8064bcc3febc501d94170c6fad981679"

    resource "aquor-api" do
      version "1.23.0"
      url "https://github.com/bitbrew-dev/aquor/releases/download/v#{version}/aquor-api_#{version}_linux_amd64.tar.gz",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "05fdefd3a4e0b8d36f1617e4dfa1c9101ab9160d3d544b3241b8e9a69d983f8d"
    end
  end

  def install
    bin.install "qtx"

    # aquor-api finds libitofin_ffi through an rpath of @loader_path/../lib ($ORIGIN/../lib on Linux)
    resource("aquor-api").stage do
      bin.install "bin/aquor-api"
      lib.install Dir["lib/*"]
      (doc/"libitofin").install "LICENSE.libitofin", Dir["licenses/libitofin/*"]
    end
  end

  test do
    assert_match "qtx #{version}", shell_output("#{bin}/qtx version")
    # An unknown command proves aquor-api starts and loads libitofin_ffi
    assert_match "expected serve", shell_output("#{bin}/aquor-api nope 2>&1", 1)
  end
end
