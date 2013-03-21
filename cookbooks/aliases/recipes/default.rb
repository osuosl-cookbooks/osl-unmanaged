#
# Cookbook Name:: aliases
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

# Alias `ll` to ls -l
magic_shell_alias 'll' do
  command 'ls -l'
end

# Set Vim as the default editor
magic_shell_environment 'EDITOR' do
  value 'vim'
end
