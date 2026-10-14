# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev decision model with CLI and MCP server"
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "1.5.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "a0f07cdf6f1bdaf933361e3b447276bf2ecc104d3b8d11c4a0c8293875694d02"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "f4e93607e0c5de5802db12cea335b14d1fc3c241700e03af65a46f28c60eaea2"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "95f7b326dc707a8c880e027724d67f33b9db15b9a06940efff5dc3f32e95ade9"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "d98a65a251f93dc9173f05dbe4aea697afb62e5a8959c8beda2685c5ecb9924c"
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
