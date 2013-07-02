#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow MySQL
simple_iptables_rule "postgres" do
  rule "--proto tcp --dport 5432"
  jump "ACCEPT"
end

