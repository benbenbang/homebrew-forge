#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to update SHA256 hashes in formula files
# Usage:
#   ruby scripts/update_sha256.rb formula_name.rb sha256_file.txt
#
# sha256_file.txt format:
#   binary-darwin-amd64: sha256:abc123...
#   binary-darwin-arm64: sha256:def456...
#   binary-linux-amd64: sha256:ghi789...
#   binary-linux-arm64: sha256:jkl012...

class SHA256Updater
  def initialize(formula_path, sha256_data)
    @formula_path = formula_path
    @sha256_data = sha256_data
  end

  def update!
    content = File.read(@formula_path)
    original_content = content.dup

    # Extract platform identifiers from SHA256 data
    platforms = %w[darwin-arm64 darwin-amd64 linux-arm64 linux-amd64]

    platforms.each do |platform|
      sha256 = @sha256_data[platform]
      next unless sha256

      # Pattern to match: sha256 "old_hash"
      # This works for both inline and SHA256S hash definitions
      content.gsub!(
        /("#{Regexp.escape(platform)}"\s*=>\s*)"[a-f0-9]{64}"/,
        "\\1\"#{sha256}\""
      )

      # Also update inline sha256 statements (for old-style formulas)
      if platform == "darwin-arm64"
        content.gsub!(
          /(if OS\.mac\? && Hardware::CPU\.arm\?.*?sha256\s+)"[a-f0-9]{64}"/m,
          "\\1\"#{sha256}\""
        )
      elsif platform == "darwin-amd64"
        content.gsub!(
          /(elsif OS\.mac\? && Hardware::CPU\.intel\?.*?sha256\s+)"[a-f0-9]{64}"/m,
          "\\1\"#{sha256}\""
        )
      elsif platform == "linux-arm64"
        content.gsub!(
          /(elsif OS\.linux\? && Hardware::CPU\.arm\?.*?sha256\s+)"[a-f0-9]{64}"/m,
          "\\1\"#{sha256}\""
        )
      elsif platform == "linux-amd64"
        content.gsub!(
          /(elsif OS\.linux\? && Hardware::CPU\.intel\?.*?sha256\s+)"[a-f0-9]{64}"/m,
          "\\1\"#{sha256}\""
        )
      end
    end

    if content == original_content
      puts "⚠️  No changes made - check if SHA256 patterns match"
      return false
    end

    File.write(@formula_path, content)
    puts "✅ Updated #{@formula_path}"
    true
  end

  def self.parse_sha256_file(file_path)
    data = {}
    File.readlines(file_path).each do |line|
      line.strip!
      next if line.empty? || line.start_with?("#")

      # Format: binary-darwin-amd64: sha256:abc123...
      if line =~ /^(\S+)-([^:]+):\s*sha256:([a-f0-9]{64})/
        platform = Regexp.last_match(2)
        sha256 = Regexp.last_match(3)
        data[platform] = sha256
      end
    end
    data
  end

  def self.parse_sha256_hash(hash_string)
    # Parse from command line format:
    # darwin-amd64:abc123,darwin-arm64:def456,linux-amd64:ghi789,linux-arm64:jkl012
    data = {}
    hash_string.split(",").each do |pair|
      platform, sha256 = pair.split(":")
      data[platform.strip] = sha256.strip
    end
    data
  end
end

# CLI
if __FILE__ == $PROGRAM_NAME
  if ARGV.length < 2
    puts "Usage:"
    puts "  From file: ruby update_sha256.rb formula_name.rb sha256_file.txt"
    puts "  From hash: ruby update_sha256.rb formula_name.rb 'darwin-amd64:abc,darwin-arm64:def,...'"
    puts ""
    puts "sha256_file.txt format:"
    puts "  binary-darwin-amd64: sha256:abc123..."
    puts "  binary-darwin-arm64: sha256:def456..."
    puts "  binary-linux-amd64: sha256:ghi789..."
    puts "  binary-linux-arm64: sha256:jkl012..."
    exit 1
  end

  formula_path = ARGV[0]
  sha256_input = ARGV[1]

  unless File.exist?(formula_path)
    puts "❌ Formula file not found: #{formula_path}"
    exit 1
  end

  sha256_data = if File.exist?(sha256_input)
                  SHA256Updater.parse_sha256_file(sha256_input)
                else
                  SHA256Updater.parse_sha256_hash(sha256_input)
                end

  if sha256_data.empty?
    puts "❌ No valid SHA256 data found"
    exit 1
  end

  puts "📝 Updating SHA256 hashes:"
  sha256_data.each do |platform, sha256|
    puts "   #{platform}: #{sha256[0..15]}..."
  end
  puts ""

  updater = SHA256Updater.new(formula_path, sha256_data)
  success = updater.update!

  exit(success ? 0 : 1)
end
