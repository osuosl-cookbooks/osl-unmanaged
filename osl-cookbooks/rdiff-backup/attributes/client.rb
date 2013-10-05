# Default attributes.
node.default['rdiff-backup']['client']['ssh-port'] = "22"
node.default['rdiff-backup']['client']['source-dirs'] = [""]
node.default['rdiff-backup']['client']['destination-dir'] = "/data/rdiff-backup"
node.default['rdiff-backup']['client']['retention-period'] = "3M"
node.default['rdiff-backup']['client']['additional-args'] = ""
node.default['rdiff-backup']['client']['user'] = "rdiff-backup-client"

# This is required for sudo access to work.
node.default['authorization']['sudo']['include_sudoers_d'] = true
