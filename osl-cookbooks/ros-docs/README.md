ros-docs Cookbook
=================
This cookbook configures the doxygen user, mount point and virtual host for docs.ros.org.

Requirements
------------
Tested on CentOS 6.x and Chef 11.

#### packages
- `apache2` - ros-docs needs apache2 to configure the virtual host.
- `user` - ros-docs needs user to configure the rosbot user_account.
- `firewall` - ros-docs needs osl's firewall to configure the firewall.
- `base::glusterfs` - ros-docs assumes glusterfs mount for documentation and depends on base::glusterfs.

Attributes
----------
#### ros-docs::user
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ros-docs']['user']</tt></td>
    <td>String</td>
    <td>The name of the docs user</td>
    <td><tt>rosbot</tt></td>
  </tr>
  <tr>
    <td><tt>['ros-docs']['ssh_keys']</tt></td>
    <td>Array</td>
    <td>An array of public keys to be added to the ['ros-docs']['user'] authorized_keys file.</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

#### ros-docs::gluster
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ros-docs']['glustervol']</tt></td>
    <td>String</td>
    <td>The path of the Gluster server + Gluster volume to add to fstab (e.g. fs1.example.com:/docs).</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['ros-docs']['glusterpath']</tt></td>
    <td>String</td>
    <td>The path of the Gluster mount to add to fstab (e.g. /data).</td>
    <td><tt>/data</tt></td>
  </tr>
</table>

#### ros-docs::apache
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ros-docs']['server_name']</tt></td>
    <td>String</td>
    <td>The Apache ServerName for the docs vhost.</td>
    <td><tt>node['fqdn']</tt></td>
  </tr>
  <tr>
    <td><tt>['ros-docs']['server_aliases']</tt></td>
    <td>Array</td>
    <td>The Apache ServerAliases for the docs vhost.</td>
    <td><tt>node['hostname']</tt></td>
  </tr>
  <tr>
    <td><tt>['ros-docs']['docroot']</tt></td>
    <td>String</td>
    <td>The Apache DocumentRoot for the docs vhost.</td>
    <td><tt>node['ros-docs']['glusterpath']/docs</tt></td>
  </tr>
</table>

Usage
-----
#### ros-docs::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `ros-docs` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ros-docs]"
  ]
}
```

Contributing
------------
1. Fork the repository on GitHub
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

License and Authors
-------------------
* Author:: Rudy Grigar <rudy@osuosl.org>

* Copyright:: 2013, OSU Open Source Lab

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
