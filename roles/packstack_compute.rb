name "packstack_compute"
description "Main setup for packstack compute nodes"
run_list  "recipe[osl-packstack]", "role[base_managed]"
override_attributes "osl-packstack" => {
  "rdo" => {
    "release" => "havana"
  },
  "type" => "compute"
}, "users" => [
  "packstack-root",
  "packstack-nova"
],
"authorization" => {
    "sudo" => {
      "include_sudoers_d" => true
  }
}
