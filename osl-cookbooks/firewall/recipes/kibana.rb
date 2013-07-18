#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Kibana
node['logstash']['server']['allowed_ip_ranges'].each do |iprange|
    simple_iptables_rule "http-kibana" do
      rule "--proto tcp --source #{iprange} --dport 8080"
      jump "ACCEPT"
    end
end
