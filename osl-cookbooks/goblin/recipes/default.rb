#
# Cookbook Name:: goblin
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

package %w{moreutils libsasl2-dev libldap2-dev python2.6-dev ldap-utils libnet-oauth-perl libmail-imapclient-perl} do
  action :install
end
