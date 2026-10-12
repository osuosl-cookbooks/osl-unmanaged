# osl-unmanaged

Sets up an unmanaged host with sane settings

Unmanaged hosts are not attached to a Chef server. `bootstrap/install.sh`
installs Cinc Client, vendors this cookbook with Berkshelf, converges
`bootstrap/runlist/unmanaged.json` in local mode, and then removes Cinc again,
so everything here has to be correct in a single run. The same recipes are used
to build OSL's OpenStack and PowerVS images.

The script fetches the cookbook itself, so it runs on a host with nothing
installed on it yet:

```sh
curl -L https://raw.githubusercontent.com/osuosl-cookbooks/osl-unmanaged/main/bootstrap/install.sh | bash
```

## Requirements

### Platforms

- AlmaLinux 8, 9, 10
- CentOS Stream 9, 10
- Debian 11, 12, 13
- Rocky Linux 8, 9, 10
- Ubuntu 20.04, 22.04, 24.04, 26.04

Fedora is handled by the recipes and tested in Test Kitchen, but is not
declared in `metadata.rb`.

### Cookbooks

- [line](https://supermarket.chef.io/cookbooks/line)

## Attributes

| Attribute | Default | Description |
| --------- | ------- | ----------- |
| `['osl-unmanaged']['osuadmin']['password']` | a SHA-512 crypt hash | Password for the `osuadmin` support user. The `OSUADMIN_PASSWD` environment variable takes precedence when it is set. |
| `['osl-unmanaged']['packer']` | `false` | Set to `true` for image builds: automatic-update units are disabled rather than enabled, so a freshly booted image does not start patching itself mid-provision. |

## Recipes

| Recipe | Description |
| ------ | ----------- |
| `default` | Includes `repos`, `packages`, `ssh`, `sudo`, `osuadmin`, `chrony`, `postfix`, `fail2ban` and `raid`, plus `rsct` on POWER10 hosts. |
| `chrony` | Installs chrony with `port 0` and `cmdport 0` so it does not listen, and enables the service. |
| `cleanup` | Strips an image before capture: removes the compilers and desktop cruft the installer left behind, `iwl*` firmware, persistent-net rules, leftover `ifcfg` files and the packer entry in `/etc/hosts`. |
| `fail2ban` | Installs fail2ban with the OSL `jail.local`. |
| `network` | Hands networking to NetworkManager: removes installer-written netplan and cloud-init config, disables `systemd-resolved` and `systemd-networkd-wait-online`, and works around the dhclient AppArmor bug. |
| `openstack` | OpenStack image prep — serial console in the grub cmdline, `GRUB_TIMEOUT=0`, cloud-init overrides and an initramfs rebuild. Includes `default` and `network`. |
| `osuadmin` | Creates the `osuadmin` support user with its `authorized_keys` and a sudoers file. |
| `packages` | Installs the base package set (`rsync` and `vim`). |
| `postfix` | Purges exim, installs postfix listening on loopback only and relaying through `smtp.osuosl.org`. |
| `powervs` | PowerVS image prep — multipath config and the extra kernel modules package. Includes `default`, `postfix`, `network` and `rsct`. |
| `raid` | Installs mdadm and/or megacli for the controllers found on the host, and points mdadm alerts at `mdadm@osuosl.org`. On the Debian family it configures the [hwraid](https://hwraid.le-vert.net) repository. |
| `repos` | Points the distro repositories at OSL mirrors, adds EPEL on the RHEL family, configures unattended upgrades or `dnf-automatic`, and installs the `osuosl-firstboot` unit. |
| `rsct` | Installs IBM RSCT on POWER hosts — the IBM Power Tools yum repository on the RHEL family, the `ibmpackages/rsct` PPA on the Debian family. |
| `ssh` | Applies the OSL `sshd_config` settings and enables sshd. |
| `sudo` | Installs sudo, creates `/etc/sudoers.d` and drops the `requiretty` default. |

### APT repository keys

The `raid` and `rsct` recipes write their signing keys to `/etc/apt/keyrings`
and reference them with `signed-by=` in `/etc/apt/sources.list.d`. They do not
use the `apt_repository` resource, which imports keys with `apt-key` — a binary
Ubuntu 26.04 and Debian 13 no longer ship.

Note that Debian 13 rejects the `ibmpackages/rsct` signing key: its `sqv` policy
refuses the SHA-1 binding signature on that 2015 Launchpad key, so the
repository is written but cannot be verified there.

### IBM Power Tools signing keys

On the RHEL family the `rsct` recipe uses the keys `ibm-power-repo` installs
under `/opt/ibm/lop/gpg`. IBM signs its RHEL 8 and 9 repositories with the
legacy `RPM-GPG-KEY-ibm-power` and its RHEL 10 repository with
`RPM-GPG-KEY-ibm-power-v2`. EL10 cannot import the legacy key at all, because
its rpm policy rejects SHA-1 binding signatures.

## Contributing

1. Fork the repository on Github
1. Create a named feature branch (like `username/add_component_x`)
1. Write tests for your change
1. Write your change
1. Run the tests, ensuring they all pass
1. Submit a Pull Request using Github

## License and Authors

- Author:: Oregon State University <chef@osuosl.org>

```text
Copyright:: 2022-2026 Oregon State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
