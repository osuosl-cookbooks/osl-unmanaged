#
# Cookbook Name:: goblin
# Attributes:: django
#
# Copyright 2013, OSU Open Source Lab
#
#
default['goblin']['django']['adminname'] = "OSL Admin"
default['goblin']['django']['adminmail'] = "root@osuosl.org"
default['goblin']['django']['username'] = "goblin"
default['goblin']['django']['dbname'] = "django"
default['goblin']['django']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinpg"]

