#!/usr/bin/env ruby

require 'octokit'

client = Octokit::Client.new \
  :access_token => ENV['ACCESS_TOKEN']

client.auto_paginate = true

entries = []
client.org_repos('osuosl-cookbooks').map(&:name).sort.each do |name|
  entries << "[osuosl-cookbooks/#{name}]\ncheckout = git clone git@github.com:osuosl-cookbooks/#{name}.git"
end

File.open(File.join(File.dirname(__FILE__), '../.mrconfig.d/github-repos'), 'w') do |f|
  f.puts entries.join("\n\n")
end
