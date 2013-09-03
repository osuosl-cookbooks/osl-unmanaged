#
# Cookbook Name:: osl-postgresql
# Recipe:: mount
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

mount "/var/lib/pgsql" do
  device "/dev/mapper/lvm-pgsql"
  fstype "xfs"
  options "rw,noatime,logbufs=8"
  action [:enable, :mount]
end
