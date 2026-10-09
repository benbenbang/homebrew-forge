# typed: strict
# frozen_string_literal: true

# Formula for jevwise: A Go SDK for Jev, the decision model, including cli and MCP.
class Jevwise < Formula
  desc "Jev, the decision model, come with Cli and MCP "
  homepage "https://github.com/bitbrew-dev/jevwise"
  version "1.3.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_arm64"
    sha256 "565babd1795bc2f4df6d32a6ffcfb33d75eb0aee6e66e9e3981e13fd85e16385"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_darwin_amd64"
    sha256 "76f7b9157feff3baccb887252fbea569717a256e1f1c571d47c383fab0d057fc"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_arm64"
    sha256 "6865da7f5db8ea58cb27a042477f239163d30bd92d7a1ff7f0cb236e81fa991f"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_linux_amd64"
    sha256 "12c511890ce4c90223e94db5facd846db2d1614e5c71a6056c1ea427e2032275"
  elsif OS.windows? && Hardware::CPU.arm?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_windows_arm64.exe"
    sha256 "a5484cecc95510a69aba00096506a7c23e6a887ccf4eb18752ee703ea9d2f469"
  elsif OS.windows? && Hardware::CPU.intel?
    url "https://github.com/bitbrew-dev/jevwise/releases/download/v#{version}/jevwise_v#{version}_windows_amd64.exe"
    sha256 "199d00cbe56eac75b957c19ab400989640da7bac4f7f443a44e73e61ba8eeabf"
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
