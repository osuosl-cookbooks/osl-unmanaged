#!/usr/bin/env ruby

# Automatically updates ../.mrconfig.d/github-repos by querying the
# osuosl-cookbooks Github org and adding/removing config entries as necessary.
# Existing entries that are still needed are not modified so that manual edits
# can still be made.

require 'octokit'

client = Octokit::Client.new \
  :access_token => ENV['ACCESS_TOKEN']

client.auto_paginate = true

fname = File.join(File.dirname(__FILE__), '../.mrconfig.d/github-repos')
oldmap = {}
File.open(fname, 'r') do |f|
  oldentries = f.read.split("\n\n")
  oldentries.each do |e|
    # Create a map of repo names to their corresponding existing entries
    oldmap[e.gsub(%r{^.*\n.*git@github\.com:osuosl-cookbooks/(.*?)(\.git.*)?( .*)?$}, '\1')] = e
  end
end

# Only create a new entry if there wasn't already an existing entry for it
entries = []
client.org_repos('osuosl-cookbooks').map(&:name).sort.each do |n|
  if oldmap.key? n
    entries << oldmap[n]
  else
    entries << "[osuosl-cookbooks/#{n}]\ncheckout = git clone git@github.com:osuosl-cookbooks/#{n}.git"
  end
end

File.open(fname, 'w') do |f|
  f.puts entries.join("\n\n")
end
