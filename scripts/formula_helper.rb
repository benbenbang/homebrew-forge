# typed: strict
# frozen_string_literal: true

require_relative "github_prv_repo_download_strategy"

# Helper module for creating Homebrew formulas with less boilerplate
# Supports both binary releases and source builds
module FormulaHelper
  # Configuration for a binary release formula
  class BinaryConfig
    attr_accessor :owner, :repo, :version, :binary_name, :sha256s, :use_private_repo

    def initialize(owner:, repo:, version:, binary_name:, sha256s: {}, use_private_repo: false)
      @owner = owner
      @repo = repo
      @version = version
      @binary_name = binary_name
      @sha256s = sha256s
      @use_private_repo = use_private_repo
    end

    # Platform identifier for release assets
    def platform_identifier
      if OS.mac? && Hardware::CPU.arm?
        "darwin-arm64"
      elsif OS.mac? && Hardware::CPU.intel?
        "darwin-amd64"
      elsif OS.linux? && Hardware::CPU.arm?
        "linux-arm64"
      elsif OS.linux? && Hardware::CPU.intel?
        "linux-amd64"
      end
    end

    # Generate the download URL for the current platform
    def download_url
      platform = platform_identifier
      "https://github.com/#{owner}/#{repo}/releases/download/#{version}/#{binary_name}-#{platform}"
    end

    # Get SHA256 for current platform
    def sha256_for_platform
      platform = platform_identifier
      sha256s[platform] || sha256s[platform.to_sym]
    end
  end

  # Configuration for a source build formula
  class SourceConfig
    attr_accessor :owner, :repo, :version, :revision, :build_system, :build_deps, :install_block

    # build_system: :cargo, :go, :npm, :custom
    def initialize(owner:, repo:, version:, revision: nil, build_system: :cargo, build_deps: [], install_block: nil)
      @owner = owner
      @repo = repo
      @version = version
      @revision = revision
      @build_system = build_system
      @build_deps = build_deps
      @install_block = install_block
    end

    def git_url
      "https://github.com/#{owner}/#{repo}.git"
    end

    # Auto-detect build dependencies based on build system
    def dependencies
      return build_deps unless build_deps.empty?

      case build_system
      when :cargo
        ["rust"]
      when :go
        ["go"]
      when :npm
        ["node"]
      else
        []
      end
    end
  end

  # Setup binary formula (call this from formula class)
  def self.setup_binary(formula_class, config)
    formula_class.class_eval do
      if config.use_private_repo
        url config.download_url, using: GitHubPrivateRepositoryReleaseDownloadStrategy
      else
        url config.download_url
      end

      sha256_value = config.sha256_for_platform
      sha256 sha256_value if sha256_value

      define_method(:install) do
        binary_path = cached_download
        chmod 0755, binary_path
        bin.install binary_path => config.binary_name
      end
    end
  end

  # Setup source formula (call this from formula class)
  def self.setup_source(formula_class, config)
    formula_class.class_eval do
      if config.revision
        url config.git_url, tag: config.version, revision: config.revision
      else
        url config.git_url, tag: config.version
      end

      config.dependencies.each do |dep|
        depends_on dep => :build
      end

      if config.install_block
        define_method(:install, &config.install_block)
      else
        define_method(:install) do
          case config.build_system
          when :cargo
            system "cargo", "install", "--locked", "--root", prefix, "--path", "."
          when :go
            system "go", "build", *std_go_args(ldflags: "-s -w")
          when :npm
            system "npm", "install", "--production"
            system "npm", "run", "build" if File.exist?("package.json")
          else
            raise "Unsupported build system: #{config.build_system}"
          end
        end
      end
    end
  end
end
