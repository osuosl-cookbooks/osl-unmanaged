name "goblin_production"
description "overrides urls to point at production locations"
override_attributes(
  "goblin" => {
    "google" => {
      "domain" => "onid.oregonstate.edu",
    },
    "cyrus" => {
      "host" => "imap.onid.oregonstate.edu",
    },
    "memcache" => {
      "host" => "mig-fe.onid.oregonstate.edu:11211",
    },
    "rabbitmq" => {
      "host" => "mig-be.onid.oregonstate.edu",
    },
  },
)
