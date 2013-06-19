#
# Cookbook Name:: goblin
# Recipe:: django
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "goblin::default"
include_recipe "goblin::django"
include_recipe "apache2::mod_wsgi"
include_recipe "apache2::mod_auth_cas"
include_recipe "memcached"

memcached_instance "goblin"

# Allow HTTP/HTTPS
simple_iptables_rule "http" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443",
         "--proto tcp --dport 8000" ]
  jump "ACCEPT"
end

web_app "goblin" do
  server_name node['hostname']
  template "apache.erb"
end
