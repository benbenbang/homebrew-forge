# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev decision model with CLI and MCP server"
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "2.0.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "68ec2750977bee36b03303f32b3115cc008970e23b740c39a7c2847d76a8337f"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "bdaba8b819032b3126eb8ff20d5e5fa388c48eb824f5ee70fa710f0ffe270150"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "42fa9d42750b5d55801dc31c061007da7d4971a1b9abe53441f949a450c6ba05"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "26270348f0d322cb05f05d95853061fddbcefc79a644f856f5adece354c6bc4f"
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
