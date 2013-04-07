#
# Cookbook Name:: firewall
# Recipe:: nrpe
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow NRPE checks
monitoringnodes = search(:node, "role:monitoring")
monitoringnodes.each do |node|
  simple_iptables_rule "nrpe" do
    rule [ "--proto tcp --source #{node['ipaddress']} --dport 5666" ]
    jump "ACCEPT"
  end
end
