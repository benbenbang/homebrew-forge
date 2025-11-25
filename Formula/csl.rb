# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../scripts/github_prv_repo_download_strategy"

# Formula for csl - Consilium CLI
class Csl < Formula
  desc "Consilium CLI for development workflows"
  homepage "https://github.com/benbenbang/consilium"
  version "1.5.0"
  license "Proprietary"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2f0159db194161550f85dc87b6ddb4b57e442f7fcfe12328c25aef3c5967380b"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "066d2c14268280dfd2fcdcd047ebde60c433520f2492b72e5ddfc5c2d6ced456"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "1374f242602f6e8a9293cac197f3cf0587e3fd3c0a2338553bed77d3e6b239ef"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/consilium/releases/download/#{version}/csl-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "c8e48dd3f6b2a68b658d970e27a2d3138c9bdb19bdb5ff94c8d2c990e4a2b779"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "csl"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "csl", shell_output("#{bin}/csl --help")
  end
end
