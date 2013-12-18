name "packstack"
description "Main setup for packstack nodes"
run_list  "recipe[osl-packstack]", "role[base_managed]"
override_attributes "osl-packstack" => {
  "rdo" => {
    "release" => "havana"
  },
  "type" => "not_compute"
}, 
"users" => [
  "packstack-root"
],
"authorization" => {
  "sudo" => {
    "include_sudoers_d" => true
  }
}
