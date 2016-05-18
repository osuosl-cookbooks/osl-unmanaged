#!/usr/bin/env ruby

# Automatically updates ../.mrconfig.d/github-repos by querying the
# osuosl-cookbooks Github org and adding/removing config entries as necessary.
# Existing entries that are still needed are not modified so that manual edits
# can still be made.
#
# To use, get an GitHub API token with read access to all private repos in the
# osuosl-cookbooks organization and export it first:
#
# $ export GITHUB_TOKEN=exampletoken
# $ ./update_mr_osl_repos.rb
#
# Then just make a PR with the changes.

require 'octokit'

client = Octokit::Client.new \
  access_token: ENV['GITHUB_TOKEN']

begin
  client.user
rescue Octokit::Unauthorized => err
  STDERR.puts "Login failure; exiting: #{err.message}"
  exit 1
end

client.auto_paginate = true

fname = File.join(File.dirname(__FILE__), '../.mrconfig.d/github-repos')
oldmap = {}
File.open(fname, 'r') do |f|
  oldentries = f.read.split("\n\n")
  oldentries.each do |e|
    # Create a map of repo names to their corresponding existing entries
    regex = %r{^.*\n.*git@github\.com:osuosl-cookbooks/(.*?)(\.git.*)?( .*)?$}
    oldmap[e.gsub(regex, '\1')] = e
  end
end

# Only create a new entry if there wasn't already an existing entry for it
entries = []
client.org_repos('osuosl-cookbooks').map(&:name).each do |n|
  if oldmap.key? n
    entries << oldmap[n]
  else
    entries << "[osuosl-cookbooks/#{n}]
checkout = git clone git@github.com:osuosl-cookbooks/#{n}.git"
  end
end

File.open(fname, 'w') do |f|
  f.puts entries.sort.join("\n\n")
end
