name "lanparty"
description "ermahgerd lanparty role"
run_list(
  "role[base]",
  "recipe[lanparty]",
  "recipe[lanparty::urbanterror]",
  "recipe[firewall::lanparty]"
)
