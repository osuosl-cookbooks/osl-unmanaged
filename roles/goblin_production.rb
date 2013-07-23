name "goblin_production"
description "overrides urls to point at production locations"
override_attributes(
  "goblin" => {
    "google" => {
      "domain" => "onid.oregonstate.edu",
      "login" => "admin_googlemig@oregonstate.edu",
    },
    "celery" => {
      "concurrency" => "30",
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
