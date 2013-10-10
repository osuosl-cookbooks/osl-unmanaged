racktables Cookbook
===================
Cookbook for managing and deploying [Racktables](http://racktables.org/).


Requirements
------------
TODO: List your cookbook requirements. Be sure to include any
requirements this cookbook has on platforms, libraries, other cookbooks,
packages, operating systems, etc.

e.g.
#### packages
- `toaster` - racktables needs toaster to brown your bagel.

Attributes
----------

#### racktables::default

* node["racktables"]["install_method"]

  Method to install racktables.

  Options:
    * 'source'

  Default: 'source'

* node["racktables"]["source"]

  Source of the racktables tarball.

  Default: "http://sourceforge.net/projects/racktables/files/RackTables-0.20.4.tar.gz/download"

* node["racktables"]["checksum"]

  MD5 Checksum of the tarball to be downloaded.

* node["racktables"]["dir"]

  Directory to install racktables to.

  Default: '/var/www/racktables'

* node["racktables"]["redirect_http"] 

  Redirect all HTTP traffic to HTTPS

  Default: true

* node["racktables"]["ssl_enabled"]

  Enable SSL.

  Default: true

* node["racktables"]["ssl_listen_ports"]

  Ports on which SSL should listen.

  Default: ["443"]

* node["racktables"]["cert_path"] 
  
  Path to the SSL certificate file.

  Default: '/etc/pki/tls/certs/wildcard.pem'

* node["racktables"]["key_path"]
  
  Path to the SSL key file.

  Default: '/etc/pki/tls/private/wildcard.key'

* node["racktables"]["db"]["name"]

  Database name.

  Default: 'racktables\_db'

* node["racktables"]["db"]["user"]

  Database user.

  Default: 'racktables\_user'

* node["racktables"]["db"]["password"]

  Database password. Should be stored in an encrypted databag.

  Default: 'password'

Usage
-----
#### racktables::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `racktables` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[racktables]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for
contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
