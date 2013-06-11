#
# Cookbook Name:: goblin
# Attributes:: django
#
# Copyright 2013, OSU Open Source Lab
#
#
default['goblin']['django']['adminname'] = "OSL Admin"
default['goblin']['django']['adminmail'] = "root@osuosl.org"
default['goblin']['django']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["ldap"]["login"]
default['goblin']['ldap']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["ldap"]["password"]
default['goblin']['ldap']['username'] = "uid=onid_googlesync,ou=specials,o=orst.edu"
default['goblin']['google']['secret'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["login"]
default['goblin']['google']['login'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["secret"]
default['goblin']['google']['key'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["key"]
default['goblin']['rabbitmq'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["rabbitmq"]

