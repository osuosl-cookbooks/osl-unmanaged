default['apache']['default_site_enabled'] = false

total_memory = node['memory']['total']

mem = (total_memory.split("kB")[0].to_i / 1024) # in MB

max_clients = ((mem - 512) / 150).floor

if max_clients < 5 do
    max_clients = 5
end

default['apache']['prefork']['maxclients'] = max_clients
