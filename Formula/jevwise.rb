# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev, the decision model, come with Cli and MCP "
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "1.4.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "e5c4fb8c0cfc6dd3f4cebc364ec51cb9bc803f56c5e3a2abbd96bf9c56c8ca6b"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "9dfd103e3442a5a811933bc0002d846429e2ba9a362aedf67d6dd02266a0a4a0"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "726a2d517e3a51fd4a42141bd6d3ae59ebb389bcae2f126188e9103a44a39aa5"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "e811b0513672bef4ba20c72ac16bacb804ba43d616dc54a67662ec28e50ab72f"
  elsif OS.windows? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_windows_arm64.exe"
    sha256 "d14aa8f090181e4704a50883bedf354be088e8006f0697c024db583acaf64eb8"
  elsif OS.windows? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_windows_amd64.exe"
    sha256 "2fc52b9a14ea08736a9a0668b3e7704d6a9bf6836bd8dd652f731638c40bffe1"
  end

  def install
    bin.install "jevwise"
    mv bin/"jev", bin/"jevwise"
    # The download is the binary itself, named after the release asset
    bin.install Dir["jevwise_v#{version}_*"].first => "jevwise"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "jev", shell_output("#{bin}/jevwise --help")
    assert_match "Make decisions with Jev", shell_output("#{bin}/jevwise --help")
  end
end
