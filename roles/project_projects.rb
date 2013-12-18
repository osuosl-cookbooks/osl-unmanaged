name "project_projects"
description "role for all project servers that don't fit into any other project categories"
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "destination-dir" => "/data/rdiff-backup-projects",
    }
  }
)
