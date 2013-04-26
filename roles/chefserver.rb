name "chefserver"
description "ermahgerd chef server role"
run_list(
  "role[base_managed]",
  "recipe[firewall::http]"
)
default_attributes(
  "chef_server" => {
    "url" => "https://chef.osuosl.org"
  }
)
