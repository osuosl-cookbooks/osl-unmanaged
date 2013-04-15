#
# Cookbook Name:: lanparty
# Recipe:: default
#
# Copyright 2013, OSU Open Source Lab
#
# All rights reserved - Do Not Redistribute
#

user_account "#{node['lanparty']['game_user']}" do
  password "#{node['lanparty']['password']}"
  home "/home/#{node['lanparty']['game_user']}"
  ssh_keys [
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkFF4bzLx43Z0rR/OTdHYPrjdjGEJ2pGKJ3aAGW+oWGzLWh+5UWAYzVMf4TzCn+e5TryxvcuVh8TFU6mi4uX45VRgwjfofsTAzA2OP1RSFwbJ5685C0J4FGS8njDYKqz6zuiorsSLKDcUoZY37SmbfJvNe216vcJ1C58laa3h23aUwmop9F/VNVufLfTtfr7yV11RyRbbd9/q4jJgEQKTeidhbKIMq2t53lAqlgSe+OEn6iNbExxQdUZEg1dpCvuDFPeWW1mq4wAKOKXnk+Md3r+VtTbVeEVsw+xo71Liushz74swt8KDxQh7K6NopEqPPDjOHrPMUAW1l1S/LccvgeJnXBKBiJjVsZffKjCM2o35ouEtEnUuuBw8Hop8HnEdKEvc23oQQSX+FFXqW9ZKx2nrqFIOFBBhRZRMJ2gjUZyGKpxxKoYMnvWZmMxUO2XL3UA8FpAWZm9ahQm9xllQgWPqvquWZYkx0rsTbygkzl8RfqcPyUC0KoU9kmYe1qIB83PxvzdGCO/bLH9mIeoxlF2+lQ069UHp608wb4Q7YfMWtdNVWMAABZ9Oofao8n4g6iNES3y2Leg+XuzKFGxnhp+YqIMTGtnjWErcmmpVkAsf8kFoGmqamjhmNrx3kAZsNQLV+PDZjFKkb0iXxjNxgCX7M73K0MqNdtLkq3jZxMQ== osuosl managed',
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8sU/cPksdvA8gXwsNmo8p1m3QGuzn8jLcnM1fUIpzS1fWzIUmUyh15DIbJSXvNHN00LcpTjDQUnAjBEMIGZKPTHuanoNLd3pG1m8DPamSHlbK7juJKJPLAvzkwFxugP7joeiEMWVpgtdyq/CsFPGRaNJvAh4qfljRFN8BOI49Ktr67bs++PUjsfpwxWlgiO8pAWvn6yo/UiqufXwtoWAuypCGaULcnn/0fKFajZaaRt3x6DINrrd14sfDXK4tZu1p+iE6jQTqOzIJ8Aq2CAEvYgs5HCezHW2rP+BGGdHM4dmjlDBitAEB+rYU4WFY2yDLqxIOG9RtQ1Nnh6BNpvqR',
    'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAgEAxD27fiYnaBPH+pHthbWX9xY+6B9/2Le20KYVfnQdIPMnZcQ0WLKul50HuObWtU+zpjrYcv4+gEMPLY2qCddXoN8s9NUXsjZ2axQ0taNOOVMf6tzwgEOW3KrnN3DCT2c0eteTQH5UA8WNGpEI4jUg95arSw/xYTjn0uHVgWEU4b/51sDenNadWaCnLxsy5NgMUVAPm5Zmdpk1zjspDs9x1GcCy4HxArogRx2I25na8EwDlgT2PiGvtJ3B7UDrC9/WY6FVCmRG2zQs4UNLxIqgH6aptR+grNBzzsshVpBxd+kAPEqfoiFUcBHB2EtIRjjOVvnoxN9ghCcFk+S+8ZcdENhidzl9+OiugLwCuEcz+FF1BOkKTslc2GDImdGHd6iGTzHFrQ5LYpyFVbwaX7n2Z90Hp6rTagKahWCYzjfcSRZHRCjSdkTXtrfU2GKBJ4d0JTiYDk1uItSNpffFWncxalCUWyOFWDQaplehWIH5qZ5I+fjJ91IMeBxZO6InEtzidUV2LVaAK6Mn13mXJ/WLSUCOspD8T4TgnYzKQFW3citKnRJC9m7jZJ/fYlr9w9sLow/Lpixh/lWo+uxpY2u5ziQLxWBrD6hazDG25a9cASTFdGWRwYI3UrVVgF3G4zELFTQCSTWi86uWT622oGvqOTF1v2hUm18OtBGl3Yssius= basic@manniefresh'
  ]
end

directory "#{node['lanparty']['game_dir']}" do
  owner "#{node['lanparty']['game_user']}"
  group "#{node['lanparty']['game_group']}"
  mode 00755
end