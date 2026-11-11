# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev decision model with CLI and MCP server"
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "1.8.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "5d115c767c2248962121a946c564aa928307f79878315dac7c034bd2e97b9026"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "75322601b5e175602aaef407004211fba400e1ce7ab1744934df9508043a2025"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "68f8a421060b94475b96fc206fb7ae618e6124498865a2eb08966535b85e2a39"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "0f15fd7226176adb69b4d6ef3d8f3c0f36b6bd38c65deb877458e521b1579017"
  end

  def install
    # The download is the binary itself, named after the release asset
    bin.install Dir["jevwise_v#{version}_*"].first => "jevwise"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "Make decisions with Jev", shell_output("#{bin}/jevwise --help")
  end
end
