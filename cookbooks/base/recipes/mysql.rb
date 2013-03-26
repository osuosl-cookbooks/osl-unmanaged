#
# Cookbook Name:: base
# Recipe:: mysql
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# add the Percona GPG key
yum_key "RPM-GPG-KEY-percona" do
  url "http://www.percona.com/downloads/RPM-GPG-KEY-percona"
  action :add
end

# Configure the Percona yum repository
yum_repository "percona" do
  repo_name "percona"
  description "CentOS $releasever - Percona"
  url "http://repo.percona.com/centos/$releasever/os/$basearch/"
  key "RPM-GPG-KEY-percona"
  action :add
end

# Remove these packages if they exist
package "mysql" do
  action :remove
end
package "mysql-libs" do
  action :remove
end
package "mysql55-libs" do
  action :remove
end
