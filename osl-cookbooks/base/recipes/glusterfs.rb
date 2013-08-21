#
# Cookbook Name:: base
# Recipe:: glusterfs
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute


# Configure the glusterfs yum repositories
yum_repository "glusterfs" do
  action :remove
end

yum_repository "glusterfs-epel" do
  repo_name "glusterfs-epel"
  description "GlusterFS is a clustered file-system capable of scaling to several petabytes."
  url "http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.0/EPEL.repo/epel-$releasever/$basearch/"
  action :add
end

yum_repository "glusterfs-noarch-epel" do
  repo_name "glusterfs-noarch-epel"
  description "GlusterFS is a clustered file-system capable of scaling to several petabytes."
  url "http://download.gluster.org/pub/gluster/glusterfs/3.4/3.4.0/EPEL.repo/epel-$releasever/noarch"
  action :add
end

package "glusterfs" do
  action :install
end
package "glusterfs-fuse" do
  action :install
end
