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
include_recipe "certificate"

memcached_instance "goblin"

# Allow HTTP/HTTPS
simple_iptables_rule "http" do
  rule [ "--proto tcp --dport 80",
         "--proto tcp --dport 443",
         "--proto tcp --dport 8000" ]
  jump "ACCEPT"
end

certificate_manage "apachessl" do
   data_bag "ssl_key"
   cert_path "/etc/ssl/private"
   key_file "g-opt-in.onid.oregonstate.edu.crt"
   cert_file "g-opt-in.onid.oregonstate.edu.key"
   chain_file "InCommon_Server_CA.pem"
   group "www-data"
end

web_app "goblin" do
  server_name node['hostname']
  template "apache.erb"
end

directory "/var/cache/apache2/mod_auth_cas" do
  owner "www-data"
  group "www-data"
  mode 0770
end
