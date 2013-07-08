name "redmine"
maintainer "Geoffrey Corey"
maintainer_email "coreyg@osuosl.org"
license "Apache 2.0"
description "Install Redmine from Github specifically for RHEL and using postgres"
version "0.0.1"

recipe "redmine", "Install the Redmine application from the source"
recipe "redmine::source", "Install the Redmine application from the source"

%w{ git apache2 passenger_apache2 mysql postgresql apt yum database}.each do |dep|
  depends dep
 end

%w{ debian ubuntu centos redhat amazon scientific fedora suse }.each do |os|
    supports os
end
