#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Kibana
simple_iptables_rule "http-kibana" do
  rule [ "--proto tcp --dport 8080",
         "--proto tcp --sport 8080" ]
  jump "ACCEPT"
end

