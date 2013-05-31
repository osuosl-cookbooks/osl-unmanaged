default['postgresql']['config']['listen_addresses'] = '*'
default['postgresql']['config']['listen_address'] = nil

default['postgresql']['pg_hba'] = {
      :comment => "Goblin user",
      :type => "host",
      :db => "all",
      :user => "goblin",
      :addr => "128.192.4.0/24",
      :method => "md5"
    }

default['postgresql']['pg_hba']['comment'] = "Goblin user"
default['postgresql']['pg_hba']['type'] = "host"
default['postgresql']['pg_hba']['db'] = "all"
default['postgresql']['pg_hba']['user'] = "goblin"
default['postgresql']['pg_hba']['addr'] = "128.192.4.0/24"
default['postgresql']['pg_hba']['method'] = "md5"
