#
# Cookbook Name:: orvsd-web
# Recipe:: wordpress
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "orvsd-web::default"
include_recipe "nginx::default"

district_user = node['orvsdweb']['users']
district_uid = node['orvsdweb']['uid'].to_i

district_user.each do | dis_user |
    user dis_user do
        home "/home/#{dis_user}"
        username "#{dis_user}"
        uid "#{district_uid}"
        shell "/bin/bash"
        action :create
    end
    directory "#{node['orvsdweb']['wordpress']['root']}/#{dis_user}" do
        owner "alfred"
        group "alfred"
        mode "0775"
        action :create
        recursive true
    end
    district_uid += 1
end


