#
# Cookbook Name:: lanparty
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/UrbanTerror42_full_009.zip" do
  source "http://staff.osuosl.org/~basic/UrbanTerror42_full_009.zip"
  action :create_if_missing
end

bash "unzip-urt42" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    unzip UrbanTerror42_full_009.zip
    mv UrbanTerror42 /opt/
  EOH
  creates "/opt/UrbanTerror42"
end

user_account "osuadmin" do
  password '$1$ADfq3tA6$ibAPNnvwo0Wzt.i7s8Kyf/'
  home '/home/osuadmin'
  ssh_keys ['ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkFF4bzLx43Z0rR/OTdHYPrjdjGEJ2pGKJ3aAGW+oWGzLWh+5UWAYzVMf4TzCn+e5TryxvcuVh8TFU6mi4uX45VRgwjfofsTAzA2OP1RSFwbJ5685C0J4FGS8njDYKqz6zuiorsSLKDcUoZY37SmbfJvNe216vcJ1C58laa3h23aUwmop9F/VNVufLfTtfr7yV11RyRbbd9/q4jJgEQKTeidhbKIMq2t53lAqlgSe+OEn6iNbExxQdUZEg1dpCvuDFPeWW1mq4wAKOKXnk+Md3r+VtTbVeEVsw+xo71Liushz74swt8KDxQh7K6NopEqPPDjOHrPMUAW1l1S/LccvgeJnXBKBiJjVsZffKjCM2o35ouEtEnUuuBw8Hop8HnEdKEvc23oQQSX+FFXqW9ZKx2nrqFIOFBBhRZRMJ2gjUZyGKpxxKoYMnvWZmMxUO2XL3UA8FpAWZm9ahQm9xllQgWPqvquWZYkx0rsTbygkzl8RfqcPyUC0KoU9kmYe1qIB83PxvzdGCO/bLH9mIeoxlF2+lQ069UHp608wb4Q7YfMWtdNVWMAABZ9Oofao8n4g6iNES3y2Leg+XuzKFGxnhp+YqIMTGtnjWErcmmpVkAsf8kFoGmqamjhmNrx3kAZsNQLV+PDZjFKkb0iXxjNxgCX7M73K0MqNdtLkq3jZxMQ== osuosl managed','ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8sU/cPksdvA8gXwsNmo8p1m3QGuzn8jLcnM1fUIpzS1fWzIUmUyh15DIbJSXvNHN00LcpTjDQUnAjBEMIGZKPTHuanoNLd3pG1m8DPamSHlbK7juJKJPLAvzkwFxugP7joeiEMWVpgtdyq/CsFPGRaNJvAh4qfljRFN8BOI49Ktr67bs++PUjsfpwxWlgiO8pAWvn6yo/UiqufXwtoWAuypCGaULcnn/0fKFajZaaRt3x6DINrrd14sfDXK4tZu1p+iE6jQTqOzIJ8Aq2CAEvYgs5HCezHW2rP+BGGdHM4dmjlDBitAEB+rYU4WFY2yDLqxIOG9RtQ1Nnh6BNpvqR']
end
