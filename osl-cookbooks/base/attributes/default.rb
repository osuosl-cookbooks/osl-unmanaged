case node['platform_family']
when "rhel"
  default['base']['packages'] = %w[ vim bash-completion bwm-ng cronie cronie-anacron crontabs dmidecode htop iotop pv pwgen screen strace time ]
when "debian"
  default['base']['packages'] = %w[ bwm-ng cron dmidecode htop iotop pv pwgen screen strace time ]
end

default['nsswitch']['passwd'] = "files"
default['nsswitch']['shadow'] = "files"
default['nsswitch']['group'] = "files"
default['nsswitch']['hosts'] = "files dns"
default['nsswitch']['bootparams'] = "nisplus [NOTFOUND=return] files"
default['nsswitch']['ethers'] = "files"
default['nsswitch']['netmask'] = "files"
default['nsswitch']['networks'] = "files"
default['nsswitch']['protocols'] = "files"
default['nsswitch']['rpc'] = "files"
default['nsswitch']['services'] = "files"
default['nsswitch']['netgroup'] = "files"
default['nsswitch']['publickey'] = "nisplus"
default['nsswitch']['automount'] = "files"
default['nsswitch']['aliases'] = "files"

default['users'] = ['osl-root', 'osl-osuadmin']
