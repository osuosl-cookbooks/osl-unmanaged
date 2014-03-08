name "etherpad_lite"
description "etherpad-lite role for all etherpads"
run_list(
  "role[base_managed]",
  "role[nodejs]"
)
