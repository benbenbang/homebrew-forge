#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to generate or update Homebrew formulas
# Usage:
#   ruby scripts/generate_formula.rb binary owner/repo version binary_name [--private]
#   ruby scripts/generate_formula.rb source owner/repo version [--rust|--go|--npm]

require "json"
require "optparse"

class FormulaGenerator
  def initialize(owner, repo, version, type)
    @owner = owner
    @repo = repo
    @version = version
    @type = type
  end

  def generate_binary(binary_name:, use_private: false, sha256s: {})
    class_name = to_class_name(binary_name)

    template = <<~RUBY
      # typed: strict
      # frozen_string_literal: true

      #{use_private ? 'require_relative "../scripts/github_prv_repo_download_strategy"' : ''}
      require_relative "../scripts/formula_helper"

      # Formula for #{binary_name}
      class #{class_name} < Formula
        desc "TODO: Add description"
        homepage "https://github.com/#{@owner}/#{@repo}"
        version "#{@version}"
        license "TODO: Add license"

        # SHA256 hashes for each platform
        SHA256S = {
          "darwin-arm64" => "#{sha256s['darwin-arm64'] || 'TODO: Add SHA256'}",
          "darwin-amd64" => "#{sha256s['darwin-amd64'] || 'TODO: Add SHA256'}",
          "linux-arm64" => "#{sha256s['linux-arm64'] || 'TODO: Add SHA256'}",
          "linux-amd64" => "#{sha256s['linux-amd64'] || 'TODO: Add SHA256'}"
        }.freeze

        config = FormulaHelper::BinaryConfig.new(
          owner: "#{@owner}",
          repo: "#{@repo}",
          version: version,
          binary_name: "#{binary_name}",
          sha256s: SHA256S,
          use_private_repo: #{use_private}
        )

        FormulaHelper.setup_binary(self, config)

        test do
          assert_match "#{binary_name}", shell_output("\#{bin}/#{binary_name} --help")
        end
      end
    RUBY

    template
  end

  def generate_source(build_system: :cargo, revision: nil)
    binary_name = @repo.split("/").last
    class_name = to_class_name(binary_name)

    template = <<~RUBY
      # typed: strict
      # frozen_string_literal: true

      require_relative "../scripts/formula_helper"

      # Formula for #{binary_name}
      class #{class_name} < Formula
        desc "TODO: Add description"
        homepage "https://github.com/#{@owner}/#{@repo}"
        version "#{@version}"
        license "TODO: Add license"
        head "https://github.com/#{@owner}/#{@repo}.git", branch: "main"

        config = FormulaHelper::SourceConfig.new(
          owner: "#{@owner}",
          repo: "#{@repo.split('/').last}",
          version: version,
          #{revision ? "revision: \"#{revision}\"," : '# revision: "TODO: Add git commit SHA (optional)"'}
          build_system: :#{build_system}
        )

        FormulaHelper.setup_source(self, config)

        test do
          assert_match "#{binary_name}", shell_output("\#{bin}/#{binary_name} --help")
        end
      end
    RUBY

    template
  end

  private

  def to_class_name(name)
    name.split("-").map(&:capitalize).join
  end
end

# CLI
if __FILE__ == $PROGRAM_NAME
  type = ARGV[0]
  owner_repo = ARGV[1]
  version = ARGV[2]

  unless type && owner_repo && version
    puts "Usage:"
    puts "  Binary: ruby generate_formula.rb binary owner/repo version binary_name [--private]"
    puts "  Source: ruby generate_formula.rb source owner/repo version [--rust|--go|--npm] [--revision SHA]"
    exit 1
  end

  owner, repo = owner_repo.split("/")

  generator = FormulaGenerator.new(owner, repo, version, type)

  case type
  when "binary"
    binary_name = ARGV[3]
    use_private = ARGV.include?("--private")

    unless binary_name
      puts "Error: binary_name required for binary formulas"
      exit 1
    end

    puts generator.generate_binary(binary_name: binary_name, use_private: use_private)

  when "source"
    build_system = if ARGV.include?("--rust")
                     :cargo
                   elsif ARGV.include?("--go")
                     :go
                   elsif ARGV.include?("--npm")
                     :npm
                   else
                     :cargo # default
                   end

    revision_idx = ARGV.index("--revision")
    revision = revision_idx ? ARGV[revision_idx + 1] : nil

    puts generator.generate_source(build_system: build_system, revision: revision)

  else
    puts "Error: type must be 'binary' or 'source'"
    exit 1
  end
end
