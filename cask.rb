#!/usr/bin/env ruby
# frozen_string_literal: true

# cask.rb — update a Homebrew Cask's version + sha256 from GitHub release assets.
#
# Casks distribute pre-built macOS artifacts (.dmg/.pkg/.zip). Unlike package.rb
# (which handles formula binaries and source builds), this script is purpose-built
# for casks: it bumps the `version` line and refreshes each `sha256` by reading the
# checksum straight from the GitHub release asset metadata — no manual `shasum`.
#
# Usage:
#   ./cask.rb OWNER/REPO -f Casks/<name>.rb -v <version>   # bump version + sha256
#   ./cask.rb OWNER/REPO -f Casks/<name>.rb                # refresh sha256 only
#
# Example:
#   ./cask.rb benbenbang/cclog -f Casks/cclog.rb -v 1.1.0

require 'json'
require 'optparse'

options = { cask_file: nil, version: nil, repo: nil }

parser = OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} OWNER/REPO [options]"
  opts.separator ""
  opts.separator "Options:"

  opts.on("-f", "--file CASK", "Path to the cask file (auto-detected from Casks/ if omitted)") do |file|
    options[:cask_file] = file
  end

  opts.on("-v", "--version VERSION", "Version to set in the cask (omit to refresh sha256 only)") do |version|
    options[:version] = version
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    puts ""
    puts "Examples:"
    puts "  # Bump version + refresh sha256 from the new release"
    puts "  #{$PROGRAM_NAME} benbenbang/cclog -f Casks/cclog.rb -v 1.1.0"
    puts ""
    puts "  # Refresh sha256 only (re-uploaded asset, same version)"
    puts "  #{$PROGRAM_NAME} benbenbang/cclog -f Casks/cclog.rb"
    exit 0
  end
end
parser.parse!

options[:repo] = ARGV[0]

# ---- validation -------------------------------------------------------------

if options[:repo].nil?
  warn "Error: Repository (owner/repo) is required. Use -h for help."
  exit 1
end

unless options[:repo].match?(%r{^[\w\-.]+/[\w\-.]+$})
  warn "Error: Repository must be in format 'owner/repo'"
  exit 1
end

# Auto-detect a single cask under Casks/ if not given explicitly.
def find_cask_file
  files = Dir.glob('Casks/*.rb')
  return files.first if files.length == 1

  if files.empty?
    warn "Error: No cask file found under Casks/. Specify one with -f."
  else
    warn "Error: Multiple cask files found. Specify one with -f:"
    files.each { |f| warn "  - #{f}" }
  end
  nil
end

cask_path = options[:cask_file] || find_cask_file
exit 1 if cask_path.nil?

unless File.exist?(cask_path)
  warn "Error: Cask file '#{cask_path}' not found"
  exit 1
end

unless system('which gh > /dev/null 2>&1')
  warn "Error: GitHub CLI (gh) is not installed or not in PATH (brew install gh)"
  exit 1
end

# ---- fetch release asset checksums -----------------------------------------

# Returns { "asset-file-name" => "sha256hex", ... } for the release.
def fetch_release_assets(repo, version)
  puts "📦 Fetching release assets from #{repo}..."

  output = nil
  tag_found = nil

  if version
    # Releases are tagged either "v1.2.3" or "1.2.3" — try both.
    ["v#{version}", version].each do |tag|
      output = `gh release view #{tag} --repo #{repo} --json assets --jq '.assets' 2>&1`
      if $?.success?
        tag_found = tag
        break
      end
    end

    unless tag_found
      warn "Error: Could not find release 'v#{version}' or '#{version}' in #{repo}"
      warn "Available releases:"
      system("gh release list --repo #{repo} --limit 5")
      exit 1
    end
    puts "✓ Found release: #{tag_found}"
  else
    output = `gh release view --repo #{repo} --json assets --jq '.assets' 2>&1`
    unless $?.success?
      warn "Error: Failed to fetch latest release from GitHub"
      warn output
      exit 1
    end
    puts "✓ Using latest release"
  end

  begin
    assets = JSON.parse(output)
  rescue JSON::ParserError => e
    warn "Error parsing GitHub response: #{e.message}"
    exit 1
  end

  digest_map = {}
  assets.each do |asset|
    digest = asset.dig('digest')&.sub('sha256:', '')
    digest_map[asset['name']] = digest if digest && !digest.empty?
  end

  if digest_map.empty?
    warn "Error: No SHA256 digests found in release assets."
    warn "GitHub computes asset digests automatically; ensure the release has uploaded artifacts."
    exit 1
  end

  digest_map
end

# ---- patching ---------------------------------------------------------------

# Build the set of names an asset might appear as inside the cask's url line:
#   - the literal name as uploaded:            CCLog_1.0.0_universal.dmg
#   - the version-templated form (interpolated): CCLog_#{version}_universal.dmg
# Matching either keeps both styles of cask working.
def name_variants(asset_name, version)
  variants = [asset_name]
  variants << asset_name.sub(version, '#{version}') if version && asset_name.include?(version)
  variants.uniq
end

# Pair each release asset to a sha256 line and replace it.
#
# Casks conventionally write `sha256` *before* `url` (and arch-split casks repeat the
# pair inside on_arm/on_intel blocks). Rather than match across lines with regex —
# which risks pairing one block's sha256 with another block's url — we locate each
# `url` by its asset filename, then bind it to the *nearest* sha256 line. Only assets
# actually referenced by a url are touched, so extra release artifacts
# (checksums.txt, other-platform builds, ...) are ignored safely.
def update_shas(content, digest_map, version)
  lines = content.lines

  sha_re = /^\s*sha256\s+"([a-f0-9]{64})"/
  sha_idxs = lines.each_index.select { |i| lines[i] =~ sha_re }

  # Find the url line for each asset (by literal or #{version}-templated filename).
  url_for = {}
  digest_map.each_key do |asset_name|
    names = name_variants(asset_name, version)
    idx = lines.each_index.find do |i|
      lines[i] =~ /^\s*url\s+"/ && names.any? { |n| lines[i].include?(n) }
    end
    url_for[asset_name] = idx if idx
  end

  # Greedily bind each url to its nearest unclaimed sha256 line.
  claimed = {}
  updates = []
  url_for.sort_by { |_, url_idx| url_idx }.each do |asset_name, url_idx|
    sha_idx = sha_idxs.reject { |i| claimed[i] }
                      .min_by { |i| (i - url_idx).abs }
    next unless sha_idx

    claimed[sha_idx] = true
    old_digest = lines[sha_idx][sha_re, 1]
    new_digest = digest_map[asset_name]
    lines[sha_idx] = lines[sha_idx].sub(/"[a-f0-9]{64}"/, "\"#{new_digest}\"")
    updates << { name: asset_name, old: old_digest, new: new_digest }
  end

  [updates, lines.join]
end

# ---- main -------------------------------------------------------------------

content = File.read(cask_path)

current_version = content[/version\s+"([^"]+)"/, 1]
unless current_version
  warn "Error: Could not find a `version \"...\"` line in #{cask_path}"
  exit 1
end

# The version that release assets are named/tagged with.
effective_version = options[:version] || current_version

digest_map = fetch_release_assets(options[:repo], options[:version])

# Bump the version line (and any literal version inside url lines, for non-interpolated casks).
if options[:version] && options[:version] != current_version
  content.gsub!(/(version\s+)"[^"]+"/, "\\1\"#{options[:version]}\"")
  content.gsub!(/(url\s+"[^"]*)#{Regexp.escape(current_version)}/, "\\1#{options[:version]}")
  puts "✓ Version: #{current_version} → #{options[:version]}"
end

updates, content = update_shas(content, digest_map, effective_version)

if updates.empty?
  warn "Warning: No sha256 values updated."
  warn "Check that the cask's url filename matches a release asset (literal or #{'#{version}'}-templated)."
  exit 1
end

File.write(cask_path, content)

puts "✓ Cask '#{cask_path}' updated successfully!"
puts "\n📝 Updated #{updates.length} checksum(s):"
updates.each do |u|
  if u[:old] == u[:new]
    puts "  • #{u[:name]} (unchanged)"
  else
    puts "  ✓ #{u[:name]}"
    puts "    #{u[:old][0..15]}... → #{u[:new][0..15]}..."
  end
end
