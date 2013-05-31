default['postgresql']['config']['listen_addresses'] = '*'

default['postgresql']['pg_hba'] = [{
      :type => 'host',
      :db => 'all',
      :user => 'goblin',
      :addr => '128.193.4.0/24',
      :method => 'md5'
    }]
