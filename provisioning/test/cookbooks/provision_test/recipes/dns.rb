master_ips = []
slave_ips = []

unless Chef::Config[:solo]
  search(:node, 'recipes:osl-dns\:\:master',
         filter_result: { 'ip' => %w(cloud public_ipv4) }).each do |result|
    master_ips << result['ip']
  end
  search(:node, 'recipes:osl-dns\:\:slave',
         filter_result: { 'ip' => %w(cloud public_ipv4) }).each do |result|
    slave_ips << result['ip']
  end
end

node.default['osl-dns']['repository'] = 'git@github.com:osuosl/zonefiles-test.git'
node.default['osl-dns']['masters'] = master_ips.empty? ? [] : master_ips
node.default['osl-dns']['slaves'] = slave_ips.empty? ? [] : slave_ips
node.default['osl-dns']['auth_ips'] = [node['cloud']['local_ipv4']]
node.default['osl-dns']['caching_ips'] = [node['cloud']['public_ipv4'], '127.0.0.1']
