name "project_drupal"
description "role for all Drupal servers"
default_attributes(
  "rdiff-backup" => {
    "client" => {
      "destination-dir" => "/data/rdiff-backup-drupal",
    }
  }
)
