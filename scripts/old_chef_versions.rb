#!/usr/bin/env ruby

require 'json'

f = File.expand_path('../../environments/production.json', __FILE__)
env = JSON.parse(File.read(f))

prod_chef_version = env['override_attributes']['omnibus_updater']['version']

query = 'chef_environment:phpbb '\
  'OR chef_environment:phase_out_nginx '\
  'OR chef_environment:openstack_production '\
  'OR chef_environment:production '\
  'AND machine:x86_64'

old_nodes = {}
search(:node, query) do |n|
  version = n['chef_packages']['chef']['version']
  old_nodes[n.name] = version if version != prod_chef_version
end

sorted = old_nodes.sort_by { |_k, v| v }.to_h
puts JSON.pretty_generate(sorted)
