# User config
default['ros-docs']['user'] = "rosbot"
default['ros-docs']['ssh_keys'] = nil
default['ros-docs']['linkpath'] = "/home/#{node['ros-docs']['user']}/docs"

# Gluster config
default['ros-docs']['glustervol'] = nil
default['ros-docs']['glusterpath'] = "/data"

# Apache2 config
default['ros-docs']['server_name'] = node['fqdn']
default['ros-docs']['server_aliases'] = nil
default['ros-docs']['docroot'] = "#{node['ros-docs']['glusterpath']}/docs"
