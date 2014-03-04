name "etherpad_lite"
description "etherpad-lite role for all etherpads"
run_list(
  "role[base]",
  "role[nodejs]"
)
