#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Install and require the mail handler gem
chef_gem "chef-handler-mail" do
  action :install
end
gem 'chef-handler-mail'

# Send email to root
chef_handler "MailHandler" do
  source 'chef/handler/mail'
  arguments :to_address => "chef@osuosl.org"
  action :nothing
  supports :exception => true, :report => false
end.run_action(:enable)
