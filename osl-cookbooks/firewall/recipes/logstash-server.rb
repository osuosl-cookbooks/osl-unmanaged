#
# Cookbook Name:: firewall
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

node['logstash']['server']['allowed_ip_ranges'].each do |iprange|
  # Allow Logstash
    simple_iptables_rule "logstash" do
      rule "--proto tcp --source #{iprange} --dport 5000"
      jump "ACCEPT"
    end
end
