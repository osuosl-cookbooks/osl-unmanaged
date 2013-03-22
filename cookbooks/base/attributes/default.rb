case node['platform']
when "redhat","centos","scientific","amazon"
  default['base']['packages'] = %w[ bwm-ng dmidecode htop iotop pwgen screen strace time ]
end
