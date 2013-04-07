case node['platform_family']
when "rhel"
  default['base']['packages'] = %w[ bwm-ng dmidecode htop iotop pwgen screen strace time ]
when "debian"
  default['base']['packages'] = %w[ bwm-ng dmidecode htop iotop pwgen screen strace time ]
end
