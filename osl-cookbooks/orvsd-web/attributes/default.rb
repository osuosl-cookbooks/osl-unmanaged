default['orvsdweb']['static']['root'] = "/var/www/html"
default['orvsdweb']['static']['server_name'] = "media.#{node['domain']}"
default['orvsdweb']['static']['healthcheck'] = "/index.html"
default['orvsdweb']['static']['glusterpath'] = nil
default['orvsdweb']['static']['glustervol'] = nil

default['orvsdweb']['wordpress']['root'] = "/var/www"

default['orvsdweb']['users'] = ["master", "juvenile", "helpdesk", "wesd", "threerivers", "salkeiz", "hmsc", 
                                "nsantiam", "orenterprise", "mcminnville", "amity", "skol", "bendlp",
                                "ddouglas", "pps", "skit", "phoenix", "beaverton", "ortrail", "soesd",
                                "sps", "cal", "gresham", "astoria", "ode", "fernridge", "osl", "hillsboro",
                                "ttsd", "sherman", "riverdale"]
default['orvsdweb']['uid'] = "9101"