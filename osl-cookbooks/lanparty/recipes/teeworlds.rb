# Allow incoming teeworlds traffic
simple_iptables_rule "teeworlds" do
    rule ["--proto udp --dport #{node['lanparty']['teeworlds']['net_port']}",
          "--proto tcp --dport #{node['lanparty']['teeworlds']['net_port']}"]
    jump "ACCEPT"
end
