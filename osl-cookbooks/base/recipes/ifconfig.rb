# Set up interfaces if they are defined in the data bag
begin
  net_dbag = data_bag_item('networking', @node[:fqdn].gsub(".","-"))
rescue
  net_dbag = nil
end

if net_dbag
  if net_dbag['interfaces']
    net_dbag['interfaces'].each_value do |ifcfg|
      ifconfig ifcfg['inet_addr'] do
        ignore_failure true
        device ifcfg['device']
        bootproto ifcfg['bootproto']
        mask ifcfg['mask']
        bcast ifcfg['bcast']
        onboot ifcfg['onboot'] if ifcfg['onboot']
        mtu ifcfg['mtu'] if ifcfg['mtu']
      end
    end
  end
  if net_dbag['routes']
    net_dbag['routes'].each_value do |r|
      route r['network'] do
        ignore_failure true
        gateway r['gateway']
        netmask r['netmask'] if r['netmask']
        device r['device'] if r['device']
      end
    end
  end
end
