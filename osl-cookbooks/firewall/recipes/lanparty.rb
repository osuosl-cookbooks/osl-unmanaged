#
# Cookbook Name:: firewall
# Recipe:: lanparty
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Allow Urban Terror
simple_iptables_rule "urbanterror" do
  rule [ "--proto udp --dport 27960",
         "--proto tcp --dport 27960" ]
  jump "ACCEPT"
end

