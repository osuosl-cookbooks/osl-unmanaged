#!/usr/bin/env ruby

require 'octokit'

client = Octokit::Client.new \
  :access_token => ARGV[0]

client.auto_paginate = true
user = client.user 'osuosl-cookbooks'

entries = []

client.org_repos('osuosl-cookbooks').collect { |r| r.name }.sort.each do |name|
  puts name
  entries << "[osuosl-cookbooks/#{name}]\ncheckout = git clone git@github.com:osuosl-cookbooks/#{name}.git"
end

File.open("../.mrconfig.d/github-repos", "w") do |f|
  f.puts entries.join("\n\n")
end
