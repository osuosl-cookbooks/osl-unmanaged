#
# Cookbook Name:: firewall
# Recipe:: openldap
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow OpenLDAP
simple_iptables_rule "openldap" do
  rule "--proto tcp --dport 636"
  jump "ACCEPT"
end

