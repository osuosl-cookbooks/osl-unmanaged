#
# Cookbook Name:: base
# Recipe:: glusterfs
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute


# Configure the glusterfs yum repository
yum_repository "glusterfs" do
  repo_name "glusterfs"
  description "GlusterFS repo $releasever - $basearch"
  url "http://packages.osuosl.org/repositories/centos-$releasever/glusterfs/$basearch"
  action :add
end

package "glusterfs" do
  action :install
end
package "glusterfs-fuse" do
  action :install
end
