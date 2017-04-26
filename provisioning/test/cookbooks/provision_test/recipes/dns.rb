node.default['firewall']['range']['osl_managed']['4'] << '140.211.168.0/24'
node.default['osl-dns']['masters'] = %w(140.211.9.8)
node.default['osl-dns']['slaves'] = %w(140.211.9.6 140.211.9.7)
node.default['osl-dns']['auth_ips'] = %w(140.211.9.7 140.211.9.8)
node.default['osl-dns']['caching_ips'] = %w(140.211.9.6 127.0.0.1 ::1)
