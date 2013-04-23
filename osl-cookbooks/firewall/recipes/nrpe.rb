#
# Cookbook Name:: firewall
# Recipe:: nrpe
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow NRPE checks
mon_host = ['127.0.0.1']
if Chef::Config[:solo]
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  search(:node, "#{node['nagios']['server_role']}") do |node|
    mon_host << node['ipaddress']
  end
end
# on the first run, search isn't available, so if you're the nagios server, go
# ahead and put your own IP address in iptables config.
if node.run_list.roles.include?(node['nagios']['server_role'])
  unless mon_host.include?(node['ipaddress'])
    mon_host << node['ipaddress']
  end
end

mon_host.each do |ip|
  simple_iptables_rule "nrpe" do
    rule [ "--proto tcp --source #{ip} --dport 5666" ]
    jump "ACCEPT"
  end
end
