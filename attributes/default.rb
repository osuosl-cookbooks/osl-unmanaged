default['osl-unmanaged']['osuadmin']['password'] = '$6$S3y2eCRW3c6SjK/l$ym9rE8J7IZvzkJ5SRMYkxp2PrZ98FNkGy/leHLZU0ATm/yQqCA3l74VNLGdMWKPnhJL4JiB7jBDxj5k3.aZlj1'
default['osl-unmanaged']['rsct'] = node['cpu']['model_name'].match(/POWER10/) if node['cpu']
default['osl-unmanaged']['packer'] = false
