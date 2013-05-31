# Allow incoming Xonotic traffic
simple_iptables_rule "xonotic" do
    rule ["--proto udp --dport #{node['lanparty']['xonotic']['net_port']}",
          "--proto tcp --dport #{node['lanparty']['xonotic']['net_port']}"]
    jump "ACCEPT"
end
