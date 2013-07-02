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

default['goblin']['google']['secret'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["secret"]
default['goblin']['google']['login'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["login"]
default['goblin']['google']['key'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["key"]
default['goblin']['google']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["google"]["password"]
default['goblin']['google']['domain'] = "gtest.onid.oregonstate.edu"

default['goblin']['rabbitmq']['host'] = "test-migbe.onid.oregonstate.edu"
default['goblin']['rabbitmq']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["rabbitmq"]

default['goblin']['cyrus']['username'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["cyrus"]["login"]
default['goblin']['cyrus']['password'] = Chef::EncryptedDataBagItem.load("goblin","credentials")["cyrus"]["password"]
default['goblin']['cyrus']['host'] = "test-cyrus-fe.onid.oregonstate.edu"

default['goblin']['memcache']['host'] = "test-migfe.onid.oregonstate.edu:11211"


