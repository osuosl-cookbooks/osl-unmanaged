#
# Cookbook Name:: base
# Recipe:: oslrepo
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Configure the OSL yum repository
yum_repository "osl" do
  repo_name "osl"
  description "OSL repo $releasever - $basearch"
  url "http://packages.osuosl.org/repositories/centos-$releasever/osl/$basearch"
  action :add
end
