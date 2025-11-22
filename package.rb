#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'optparse'

# Default options
options = {
  formula_file: nil,
  version: nil
}

# Parse command line options
OptionParser.new do |opts|
  opts.banner = "Usage: gh release view --repo owner/repo --json 'assets' --jq '.assets' | #{$PROGRAM_NAME} [options]"
  opts.separator ""
  opts.separator "Options:"

  opts.on("-f", "--file FORMULA", "Path to the Homebrew formula file") do |file|
    options[:formula_file] = file
  end

  opts.on("-v", "--version VERSION", "Version to update in the formula") do |version|
    options[:version] = version
  end

  opts.on("-h", "--help", "Show this help message") do
    puts opts
    puts ""
    puts "Examples:"
    puts "  # With explicit file and version"
    puts "  gh release view --repo owner/repo --json 'assets' --jq '.assets' | \\"
    puts "    #{$PROGRAM_NAME} -f csl.rb -v 1.3.0"
    puts ""
    puts "  # Auto-detect file, specify version"
    puts "  gh release view --repo owner/repo --json 'assets' --jq '.assets' | \\"
    puts "    #{$PROGRAM_NAME} --version 1.3.0"
    puts ""
    puts "  # Just update digests without changing version"
    puts "  gh release view --repo owner/repo --json 'assets' --jq '.assets' | \\"
    puts "    #{$PROGRAM_NAME} -f csl.rb"
    exit 0
  end
end.parse!

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

# Read JSON from stdin
json_input = STDIN.read
if json_input.strip.empty?
  puts "Error: No JSON data received from stdin"
  puts "Use -h or --help for usage information."
  exit 1
end

# Parse the JSON
begin
  assets = JSON.parse(json_input)
rescue JSON::ParserError => e
  puts "Error parsing JSON: #{e.message}"
  exit 1
end

# Create a mapping of platform names to digests
digest_map = {}
assets.each do |asset|
  name = asset['name']
  digest = asset['digest']&.sub('sha256:', '')

  if digest && !digest.empty?
    digest_map[name] = digest
  end
end

if digest_map.empty?
  puts "Error: No digests found in the provided JSON data"
  exit 1
end

# Read the formula file
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

# Track digest updates
updates = []

# For each asset, try to find and update its sha256 in the formula
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
  puts "Check that binary names match between JSON and formula."
  exit 0
end

# Write the updated content back
File.write(formula_path, formula_content)

puts "✓ Formula '#{formula_path}' updated successfully!"
puts "\nUpdated #{updates.length} digest(s):"
updates.each do |update|
  if update[:old] != update[:new]
    puts "  ✓ #{update[:name]}"
    puts "    #{update[:old]} → #{update[:new]}"
  else
    puts "  • #{update[:name]} (unchanged)"
  end
end
