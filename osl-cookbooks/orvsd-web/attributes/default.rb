default['orvsdweb']['static']['root'] = "/var/www/html"
default['orvsdweb']['static']['server_name'] = "media.#{node['domain']}"
default['orvsdweb']['static']['healthcheck'] = "/index.html"
default['orvsdweb']['static']['glusterpath'] = nil
default['orvsdweb']['static']['glustervol'] = nil

default['orvsdweb']['users'] = "salkeiz"