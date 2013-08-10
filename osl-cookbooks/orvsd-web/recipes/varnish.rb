#
# Cookbook Name:: orvsd-web
# Recipe:: varnish
#

# Installs and configures varnish for orvsd drupal caching
include_recipe "yum::yum"
include_recipe "firewall::http"

yum_repository "varnish" do
  name "varnish"
  description "Varnish repository for RHEL-type systems"
  url "http://repo.varnish-cache.org/redhat/varnish-3.0/el6"
  #  key "RPM-GPG-KEY-VARNISH"
  action :add
end

package "varnish"

cookbook_file "/etc/varnish/default.vcl" do
  source "default.vcl"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[varnish]", :immediately
end

cookbook_file "/etc/sysconfig/varnish" do
  source "varnish-sysconfig"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[varnish]"
end

%w{varnish varnishlog varnishncsa}.each do |varnish_service|
  service varnish_service do
    supports :restart => true, :reload => true
    action [ :enable, :start ]
  end
end
