#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'optparse'

# Default options
options = {
  formula_file: nil,
  version: nil,
  mode: nil,  # :assets or :revision
  repo: nil
}

# Parse command line options
OptionParser.new do |opts|
  opts.banner = "Usage: #{$PROGRAM_NAME} [--assets|--revision] OWNER/REPO [options]"
  opts.separator ""
  opts.separator "Modes:"
  opts.separator "  --assets      Update binary release SHA256 hashes from GitHub release assets"
  opts.separator "  --revision    Update git revision SHA for source builds"
  opts.separator ""
  opts.separator "Options:"

  opts.on("--assets", "Update binary SHA256s from release assets") do
    options[:mode] = :assets
  end

  opts.on("--revision", "--tag", "Update git revision SHA for source build") do
    options[:mode] = :revision
  end

  opts.on("-f", "--file FORMULA", "Path to the Homebrew formula file (auto-detected if not provided)") do |file|
    options[:formula_file] = file
  end

  opts.on("-v", "--version VERSION", "Version to update in the formula") do |version|
    options[:version] = version
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    puts ""
    puts "Examples:"
    puts "  # Update binary SHA256s for a release"
    puts "  #{$PROGRAM_NAME} --assets benbenbang/consilium -f Formula/csl.rb -v 1.3.0"
    puts ""
    puts "  # Update git revision for source build"
    puts "  #{$PROGRAM_NAME} --revision benbenbang/uv-shell -f Formula/uv-shell.rb -v 2.0.0"
    puts ""
    puts "  # Auto-detect formula file"
    puts "  #{$PROGRAM_NAME} --assets owner/repo --version 1.3.0"
    puts ""
    puts "  # Just update without changing version"
    puts "  #{$PROGRAM_NAME} --assets owner/repo -f Formula/tool.rb"
    exit 0
  end
end.parse!

# Get repo from first positional argument
options[:repo] = ARGV[0]

# Validate required arguments
if options[:mode].nil?
  puts "Error: Must specify either --assets or --revision"
  puts "Use -h or --help for usage information."
  exit 1
end

if options[:repo].nil?
  puts "Error: Repository (owner/repo) is required"
  puts "Use -h or --help for usage information."
  exit 1
end

unless options[:repo].match?(/^[\w\-\.]+\/[\w\-\.]+$/)
  puts "Error: Repository must be in format 'owner/repo'"
  exit 1
end

# Find formula file if not provided
def find_formula_file
  rb_files = Dir.glob('*.rb')

  if rb_files.empty?
    rb_files = Dir.glob('Formula/*.rb')
  end

  if rb_files.length == 1
    rb_files.first
  elsif rb_files.empty?
    nil
  else
    puts "Error: Multiple formula files found. Please specify with -f/--file:"
    rb_files.each { |f| puts "  - #{f}" }
    nil
  end
end

# Get formula path
formula_path = options[:formula_file] || find_formula_file

if formula_path.nil?
  puts "Error: No formula file found or specified."
  puts "Use -h or --help for usage information."
  exit 1
end

unless File.exist?(formula_path)
  puts "Error: Formula file '#{formula_path}' not found"
  exit 1
end

# Check if gh CLI is available
unless system('which gh > /dev/null 2>&1')
  puts "Error: GitHub CLI (gh) is not installed or not in PATH"
  puts "Install it with: brew install gh"
  exit 1
end

# Function to fetch release assets
def fetch_release_assets(repo, version)
  puts "📦 Fetching release assets from #{repo}..."

  tag = version ? "v#{version}" : ""
  cmd = if tag.empty?
          "gh release view --repo #{repo} --json assets --jq '.assets'"
        else
          "gh release view #{tag} --repo #{repo} --json assets --jq '.assets'"
        end

  output = `#{cmd} 2>&1`

  unless $?.success?
    puts "Error: Failed to fetch release from GitHub"
    puts output
    exit 1
  end

  begin
    assets = JSON.parse(output)
  rescue JSON::ParserError => e
    puts "Error parsing GitHub response: #{e.message}"
    exit 1
  end

  # Create digest map
  digest_map = {}
  assets.each do |asset|
    name = asset['name']
    digest = asset.dig('digest')&.sub('sha256:', '')

    if digest && !digest.empty?
      digest_map[name] = digest
    end
  end

  if digest_map.empty?
    puts "Error: No SHA256 digests found in release assets"
    puts "Make sure the release has assets with checksums"
    exit 1
  end

  digest_map
end

# Function to fetch git revision
def fetch_git_revision(repo, version)
  puts "🔍 Fetching git revision for #{repo} #{version}..."

  # Try with 'v' prefix first, then without
  tags_to_try = ["v#{version}", version]

  sha = nil
  tags_to_try.each do |tag|
    cmd = "gh api repos/#{repo}/git/ref/tags/#{tag} --jq '.object.sha' 2>&1"
    output = `#{cmd}`

    if $?.success?
      sha = output.strip
      puts "✓ Found tag: #{tag}"
      break
    end
  end

  if sha.nil?
    puts "Error: Could not find tag 'v#{version}' or '#{version}' in repository"
    puts "Available tags:"
    system("gh api repos/#{repo}/tags --jq '.[].name' | head -5")
    exit 1
  end

  if sha.empty? || sha.length != 40
    puts "Error: Invalid git SHA received: #{sha}"
    exit 1
  end

  sha
end

# Function to update binary SHA256s
def update_assets(formula_content, digest_map, formula_path)
  updates = []

  digest_map.each do |binary_name, new_digest|
    # Match the url line containing this binary name, followed by optional lines,
    # then the sha256 line
    pattern = /(url\s+"[^"]*#{Regexp.escape(binary_name)}"[^\n]*\n(?:.*?\n)*?\s*sha256\s+)"([a-f0-9]{64})"/m

    if formula_content.match?(pattern)
      old_digest = formula_content[pattern, 2]
      formula_content.gsub!(pattern, "\\1\"#{new_digest}\"")
      updates << { name: binary_name, old: old_digest, new: new_digest }
    end
  end

  if updates.empty?
    puts "Warning: No sha256 values were updated."
    puts "Check that binary names match between release assets and formula."
    return false
  end

  File.write(formula_path, formula_content)

  puts "✓ Formula '#{formula_path}' updated successfully!"
  puts "\n📝 Updated #{updates.length} digest(s):"
  updates.each do |update|
    if update[:old] != update[:new]
      puts "  ✓ #{update[:name]}"
      puts "    #{update[:old][0..15]}... → #{update[:new][0..15]}..."
    else
      puts "  • #{update[:name]} (unchanged)"
    end
  end

  true
end

# Function to update git revision
def update_revision(formula_content, new_sha, formula_path)
  # Pattern to match: revision: "old_value" (can be any string, not just 40-char SHA)
  pattern = /(revision:\s*)"([^"]*)"/

  unless formula_content.match?(pattern)
    puts "Error: Could not find revision line in formula"
    puts "Formula might not be a source-build formula"
    exit 1
  end

  old_value = formula_content[pattern, 2]

  if old_value == new_sha
    puts "✓ Revision is already up to date: #{new_sha[0..7]}"
    return true
  end

  formula_content.gsub!(pattern, "\\1\"#{new_sha}\"")
  File.write(formula_path, formula_content)

  puts "✓ Formula '#{formula_path}' updated successfully!"
  puts "\n📝 Updated git revision:"

  # Handle both short and long values in output
  old_display = old_value.length > 7 ? "#{old_value[0..7]}..." : old_value
  new_display = "#{new_sha[0..7]}..."

  puts "  #{old_display} → #{new_display}"
  puts "  Full SHA: #{new_sha}"

  true
end

# Main execution
formula_content = File.read(formula_path)

# Update version if provided
if options[:version]
  version_pattern = /(version\s+)"[^"]+"/
  if formula_content.match?(version_pattern)
    old_version = formula_content[version_pattern, 1]
    formula_content.gsub!(version_pattern, "\\1\"#{options[:version]}\"")
    puts "✓ Version updated to #{options[:version]}"
  else
    puts "Warning: Could not find version line to update"
  end
end

# Execute based on mode
case options[:mode]
when :assets
  digest_map = fetch_release_assets(options[:repo], options[:version])
  success = update_assets(formula_content, digest_map, formula_path)
  exit(success ? 0 : 1)

when :revision
  unless options[:version]
    puts "Error: Version (-v/--version) is required for --revision mode"
    exit 1
  end

  new_sha = fetch_git_revision(options[:repo], options[:version])
  success = update_revision(formula_content, new_sha, formula_path)
  exit(success ? 0 : 1)
end
