#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Munin checks
munin_host = ['127.0.0.1']
if Chef::Config[:solo]
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  search(:node, "roles:#{node['munin']['server_role']}") do |node|
    munin_host << node['ipaddress']
  end

  # on the first run, search isn't available, so if you're the munin server, go
  # ahead and put your own IP address in iptables config.
  if node.run_list.roles.include?(node['munin']['server_role'])
    unless munin_host.include?(node['ipaddress'])
      munin_host << node['ipaddress']
    end
  end
end
munin_host.each do |ip|
  simple_iptables_rule "munin" do
    rule [ "--proto tcp --source #{ip} --dport 4949" ]
    jump "ACCEPT"
  end
end
