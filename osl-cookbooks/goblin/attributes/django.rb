#
# Cookbook Name:: goblin
# Attributes:: django
#
# Copyright 2013, OSU Open Source Lab
#
#
default['goblin']['django']['adminname'] = "OSL Admin"
default['goblin']['django']['adminmail'] = "root@osuosl.org"
default['goblin']['django']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinpg"]
default['goblin']['ldap']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["goblinldap"]
default['goblin']['ldap']['username'] = "uid=onid_googlesync,ou=specials,o=orst.edu"
