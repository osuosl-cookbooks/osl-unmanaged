#
# Cookbook Name:: goblin
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

%w{moreutils libsasl2-dev libldap2-dev python2.6-dev ldap-utils libnet-oauth-perl libmail-imapclient-perl}.each do |pkg|
  package pkg
end

# Clone google-imap scripts
git "/opt/google-imap" do
  repository "git://github.com/osuosl/google-imap.git"
  reference "master"
  action :sync
end
