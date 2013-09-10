# User config
default['ros-docs']['user'] = "rosbot"
default['ros-docs']['ssh_keys'] = nil
default['ros-docs']['linkpath'] = "/home/#{node['ros-docs']['user']}/docs"

# Localmount config
default['ros-docs']['localmount'] = nil
default['ros-docs']['mountpath'] = "/data"

# Gluster config
default['ros-docs']['glustervol'] = nil
default['ros-docs']['glusterpath'] = node['ros-docs']['mountpath']

# Apache2 config
default['ros-docs']['server_name'] = node['fqdn']
default['ros-docs']['server_aliases'] = nil
default['ros-docs']['docroot'] = "#{node['ros-docs']['mountpath']}/docs"
default['ros-docs']['logs_dir'] = "/var/log/httpd/#{node['ros-docs']['server_name']}"
