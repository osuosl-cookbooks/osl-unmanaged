#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Logstash
simple_iptables_rule "logstash" do
  rule "--proto tcp --dport 5000"
  jump "ACCEPT"
end

