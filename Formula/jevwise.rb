# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev decision model with CLI and MCP server"
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "1.6.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "729dbd3f5ad4054052eb7b01b472bc887312c56f3d0d225d6533a2f8cd25500c"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "103ebec105398249b7a4180a6fd84eedbd19a61b9e3967c7bf505d87a99720e5"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "8d29248dff00eaa9a21d6a87ad6acf76a645b38d57561cee598fab4f79b7d4d0"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "6c6fe6371d9bc357a7b9c2e46c5fde99f2783538f2965d42d8ff9f8b5bccb9b1"
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
