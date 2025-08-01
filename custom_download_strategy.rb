# Production-ready custom download strategy for private GitHub repositories
require "download_strategy"
require "open3"
require "json"

class GitHubPrivateRepositoryReleaseDownloadStrategy < CurlDownloadStrategy
  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    url_pattern = %r{https://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    # Use GitHub API to get the download URL for the specific asset
    api_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"

    # Get release metadata
    release_data = fetch_release_data(api_url)

    unless release_data && release_data["assets"]
      raise CurlDownloadStrategyError, "No assets found in release or invalid release data."
    end

    # Find the asset with our filename
    asset = release_data["assets"].find { |a| a["name"] == @filename }
    unless asset
      available_assets = release_data["assets"].map { |a| a["name"] }.join(", ")
      raise CurlDownloadStrategyError, "Asset '#{@filename}' not found. Available assets: #{available_assets}"
    end

    # Download the asset using its API URL
    asset_url = asset["url"]
    curl_download asset_url,
                  "--header", "Accept: application/octet-stream",
                  "--header", "Authorization: token #{@github_token}",
                  to: temporary_path,
                  timeout: timeout
  end

  def fetch_release_data(api_url)
    cmd = ["curl", "-s", "-H", "Authorization: token #{@github_token}", api_url]
    output, status = Open3.capture2(*cmd)

    unless status.success?
      raise CurlDownloadStrategyError, "Failed to fetch release data from GitHub API (exit code: #{status.exitstatus})"
    end

    if output.empty?
      raise CurlDownloadStrategyError, "Empty response from GitHub API"
    end

    begin
      parsed = JSON.parse(output)

      # Check for API errors
      if parsed["message"]
        raise CurlDownloadStrategyError, "GitHub API error: #{parsed['message']}"
      end

      parsed
    rescue JSON::ParserError => e
      raise CurlDownloadStrategyError, "Invalid JSON response from GitHub API: #{e.message}"
    end
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"] || ENV["GITHUB_TOKEN"]

    unless @github_token
      raise CurlDownloadStrategyError, "Environment variable HOMEBREW_GITHUB_API_TOKEN is required."
    end
  end
end
