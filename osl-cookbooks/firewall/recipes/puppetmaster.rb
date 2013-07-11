#
# Cookbook Name:: firewall
# Recipe:: puppetmaster
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Puppet Master traffic
simple_iptables_rule "puppetmaster" do
  rule [ "--proto tcp --dport 8140" ]
  jump "ACCEPT"
end

