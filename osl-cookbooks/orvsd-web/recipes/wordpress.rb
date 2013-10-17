#
# Cookbook Name:: orvsd-web
# Recipe:: wordpress
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute

include_recipe "nginx::default"

district_user = data_bag('orvsd-web')

district_user.each do | dis_user |
    district = data_bag_item('orvsd-web', dis_user)
    homedir = "/home/#{dis_user}"

    user(dis_user) do
        home homedir
        uid district['uid']
        shell "/bin/bash"
    end

    directory "#{node['orvsdweb']['wordpress']['root']}/#{dis_user}" do
        owner "alfred"
        group "alfred"
        mode "0775"
        action :create
        recursive true
    end
end


