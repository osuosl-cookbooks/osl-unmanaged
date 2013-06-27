name "goblin production settings"
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
    }
  },
)
