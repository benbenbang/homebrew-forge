# typed: strict
# frozen_string_literal: true

# Include the custom download strategy
require_relative "../custom_download_strategy"

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.0.2"
  license "MIT"

  # Platform-specific URLs using the custom download strategy
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "bfcab23acc1ae9c67d48eadd4524375404fa74dfa12e36c22fa18c32b07c56dc"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-darwin-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2588644d6a59349a8e8250313d6c6b37c5307ed3a23638636d83a29ab7a4ff93"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-arm64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "2a05a9ad69c7e7625482829cc3c68f1f0dd37e1c717c53d07d1fcfb7719bd69e"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/benbenbang/preconf-cli/releases/download/#{version}/pcg-linux-amd64",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "43c004573cdcefbaea26e8a4bce11259fa48a666ff8e4032f2678bb4796d382f"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "pcg"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "pcg", shell_output("#{bin}/pcg --help")
  end
end
