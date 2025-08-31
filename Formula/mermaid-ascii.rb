# typed: strict
# frozen_string_literal: true

# Formula for mermaid-ascii: Render mermaid diagrams in your terminal. From mermaid DSL to ascii art.
class MermaidAscii < Formula
  desc "Render Mermaid graphs inside your terminal"
  homepage "https://github.com/AlexanderGrooff/mermaid-ascii"
  version "0.7.0"
  license "MIT"

  # Platform-specific URLs
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/AlexanderGrooff/mermaid-ascii/releases/download/#{version}/mermaid-ascii_Darwin_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "8ca47405ca46b023fe1722e81481d01658f45525b0af55605df13b00802147b9"
  elsif OS.mac? && Hardware::CPU.intel?
    url "https://github.com/AlexanderGrooff/mermaid-ascii/releases/download/#{version}/mermaid-ascii_Darwin_x86_64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "7c119cd5f081ae745242ac8aaadf0bf5234d2f57cc4c5e31600f8894db2be9b7"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/AlexanderGrooff/mermaid-ascii/releases/download/#{version}/mermaid-ascii_Linux_arm64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "7d9afafd74778c140f97009d2d9d1ccdf58ce6c54b8df69ff9b3124c3fba82c8"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/AlexanderGrooff/mermaid-ascii/releases/download/#{version}/mermaid-ascii_Linux_x86_64.tar.gz",
        using: GitHubPrivateRepositoryReleaseDownloadStrategy
    sha256 "ca0d607d0745c6e8522da25ea4eeb91d46dbc18fcabaea3d47638ffe3e75f565"
  end

  def install
    # Since we're downloading the binary directly, we need to handle it properly
    # The cached_download gives us the path to the downloaded file
    binary_path = cached_download

    # Make it executable
    chmod 0755, binary_path

    # Install the binary
    bin.install binary_path => "mermaid-ascii"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "mermaid-ascii", shell_output("#{bin}/mermaid-ascii --help")
  end
end
