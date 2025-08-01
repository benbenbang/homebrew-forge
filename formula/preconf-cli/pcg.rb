# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from GitHub
# Release assets. To use it, add `:using => :github_private_release` to the URL section
# of your formula. This download strategy uses GitHub access tokens (in the
# environment variables HOMEBREW_GITHUB_API_TOKEN) to sign the request.
class GitHubPrivateRepositoryReleaseDownloadStrategy < GitHubPrivateRepositoryDownloadStrategy
  def initialize(url, name, version, **meta)
    super
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    # HTTP request header `Accept: application/octet-stream` is required.
    # Without this, the GitHub API will respond with metadata, not binary.
    curl_download download_url, "--header", "Accept: application/octet-stream", "--header", "Authorization: token #{@github_token}", to: temporary_path
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub::API.open_rest(release_url)
  end
end

# Formula for pcg - Pre-commit configuration generator
class Pcg < Formula
  desc "Pre-commit configuration generator for development workflows"
  homepage "https://github.com/benbenbang/preconf-cli"
  version "1.0.2"
  license "MIT"

  # Default to macOS Intel
  url "https://github.com/benbenbang/preconf-cli/releases/download/v1.0.2/pcg-darwin-amd64",
      using: GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "2588644d6a59349a8e8250313d6c6b37c5307ed3a23638636d83a29ab7a4ff93"

  # Platform-specific binaries
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/benbenbang/preconf-cli/releases/download/v1.0.2/pcg-darwin-arm64",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "bfcab23acc1ae9c67d48eadd4524375404fa74dfa12e36c22fa18c32b07c56dc"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/benbenbang/preconf-cli/releases/download/v1.0.2/pcg-linux-amd64",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "43c004573cdcefbaea26e8a4bce11259fa48a666ff8e4032f2678bb4796d382f"
    elsif Hardware::CPU.arm?
      url "https://github.com/benbenbang/preconf-cli/releases/download/v1.0.2/pcg-linux-arm64",
          using: GitHubPrivateRepositoryReleaseDownloadStrategy
      sha256 "2a05a9ad69c7e7625482829cc3c68f1f0dd37e1c717c53d07d1fcfb7719bd69e"
    end
  end

  def install
    # Install the pcg binary
    bin.install "pcg-#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}" => "pcg"
  end

  test do
    # Test that the binary runs and shows help
    assert_match "pcg", shell_output("#{bin}/pcg --help")

    # Test version command if available
    # assert_match version.to_s, shell_output("#{bin}/pcg --version")
  end
end
