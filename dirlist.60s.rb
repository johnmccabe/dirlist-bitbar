#!/usr/bin/env ruby
require 'pathname'

REPO_DIR = "#{Dir.home}/workspaces/github/".freeze

# Returns age of the file in days.
#
# @param file [String] fully qualified path to file.
# @return [Float] age of the file in days.
def age_in_days(file)
  (Time.now - get_max_mtime(file)) / (60 * 60 * 24)
end

# Returns the `mtime` of the most recent non-dot file found in the
# requested directory hierarchy.
#
# @param dir [String] the directory to search.
# @return [Time] the most recent `mtime` found.
def get_max_mtime(dir)
  max_mtime = Dir.glob("#{dir}/**/*").max_by do |f|
    File.symlink?(f) ? Time.new(1900) : File.mtime(f)
  end
  if max_mtime.to_s.empty?
    Time.now
  else
    File.mtime(max_mtime)
  end
end

# Prints a bitbar formatted menu section containing the request range
# of repositories.
#
# @param repo_hash [Hash] a hash of directories ('String') to age in days
#   (`Float`).
# @param range_fn [Proc] a lambda used to filter the `repo_hash`
# @param title [String] the title for the menu section
# @param color [String] the color of the title
# @param submenu [TrueClass|FalseClass] whether the menu section belongs
#   in a submenu
def print_section(repo_hash, range_fn, title, color, submenu = false)
  return if repo_hash.empty?
  filtered_repo_hash = repo_hash.select { |_, age| range_fn.call(age) }
  submenu_prefix = submenu ? '-- ' : ''
  puts '---',
       "#{title} | color=#{color}"
  filtered_repo_hash.sort_by { |_k, v| v }.each do |repo, _|
    repo_basename = Pathname.new(repo).basename
    puts "#{submenu_prefix}#{repo_basename}|bash=/usr/local/bin/code param1=-n param2=#{repo} terminal=false"
  end
end

repos = Dir["#{REPO_DIR}/*"]
repo_hash = Hash[repos.map { |f| [f, age_in_days(f)] }]

puts "#{repos.length} repos"
print_section(repo_hash, ->(x) { x < 1 }, 'Today', 'green')
print_section(repo_hash, ->(x) { x > 1 && x < 2 }, 'Yesterday', 'yellow')
print_section(repo_hash, ->(x) { x > 2 && x < 3 }, 'Last 3 Days', 'orange')
print_section(repo_hash, ->(x) { x > 3 && x < 7 }, 'Last 7 Days', 'orange')
print_section(repo_hash, ->(x) { x > 7 }, 'Older than 7 Days', 'red', true)
puts '---',
     'Refresh... | refresh=true'
