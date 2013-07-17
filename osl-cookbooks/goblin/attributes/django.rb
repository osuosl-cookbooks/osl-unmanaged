#
# Cookbook Name:: goblin
# Attributes:: django
#
# Copyright 2013, OSU Open Source Lab
#
#

databag = Chef::EncryptedDataBagItem.load("goblin","credentials")

default['goblin']['django']['adminname'] = "OSL Admin"
default['goblin']['django']['adminmail'] = "root@osuosl.org"
default['goblin']['django']['password'] = databag["ldap"]["login"]

default['goblin']['ldap']['password'] = databag["ldap"]["password"]
default['goblin']['ldap']['username'] = "uid=onid_googlesync,ou=specials,o=orst.edu"

default['goblin']['google']['secret'] = databag["google"]["secret"]
default['goblin']['google']['login'] = "admin_googlemig@gtest.onid.oregonstate.edu"
default['goblin']['google']['key'] = databag["google"]["key"]
default['goblin']['google']['password'] = databag["google"]["password"]
default['goblin']['google']['domain'] = "gtest.onid.oregonstate.edu"

default['goblin']['celery']['concurrency'] = 10

default['goblin']['rabbitmq']['host'] = "test-migbe.onid.oregonstate.edu"
default['goblin']['rabbitmq']['password'] = databag["rabbitmq"]

default['goblin']['cyrus']['username'] = databag["cyrus"]["login"]
default['goblin']['cyrus']['password'] = databag["cyrus"]["password"]
default['goblin']['cyrus']['host'] = "test-cyrus-fe.onid.oregonstate.edu"

default['goblin']['memcache']['host'] = "test-migfe.onid.oregonstate.edu:11211"


