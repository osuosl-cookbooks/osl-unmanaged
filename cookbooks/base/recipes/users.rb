#
# Cookbook Name:: base
# Recipe:: users
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

include_recipe "user"

users_manage "root" do
#  id 'root'
  groups 'root'
  uid '0'
  ssh_keys 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkFF4bzLx43Z0rR/OTdHYPrjdjGEJ2pGKJ3aAGW+oWGzLWh+5UWAYzVMf4TzCn+e5TryxvcuVh8TFU6mi4uX45VRgwjfofsTAzA2OP1RSFwbJ5685C0J4FGS8njDYKqz6zuiorsSLKDcUoZY37SmbfJvNe216vcJ1C58laa3h23aUwmop9F/VNVufLfTtfr7yV11RyRbbd9/q4jJgEQKTeidhbKIMq2t53lAqlgSe+OEn6iNbExxQdUZEg1dpCvuDFPeWW1mq4wAKOKXnk+Md3r+VtTbVeEVsw+xo71Liushz74swt8KDxQh7K6NopEqPPDjOHrPMUAW1l1S/LccvgeJnXBKBiJjVsZffKjCM2o35ouEtEnUuuBw8Hop8HnEdKEvc23oQQSX+FFXqW9ZKx2nrqFIOFBBhRZRMJ2gjUZyGKpxxKoYMnvWZmMxUO2XL3UA8FpAWZm9ahQm9xllQgWPqvquWZYkx0rsTbygkzl8RfqcPyUC0KoU9kmYe1qIB83PxvzdGCO/bLH9mIeoxlF2+lQ069UHp608wb4Q7YfMWtdNVWMAABZ9Oofao8n4g6iNES3y2Leg+XuzKFGxnhp+YqIMTGtnjWErcmmpVkAsf8kFoGmqamjhmNrx3kAZsNQLV+PDZjFKkb0iXxjNxgCX7M73K0MqNdtLkq3jZxMQ== osuosl managed'
end
