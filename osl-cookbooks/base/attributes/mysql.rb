default['mysql']['tunable']['server_id'] = node['ipaddress'].split('.').collect {|o| o.to_i}.inject(0) {|acc,o| acc*256 + o}
