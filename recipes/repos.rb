#
# Cookbook:: osl-unmanaged
# Recipe:: repos
#
# Copyright:: 2022-2024, Oregon State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
if platform_family?('rhel', 'fedora')
  if centos? && node['platform_version'].to_i == 7
    filter_lines '/etc/yum.repos.d/CentOS-Base.repo' do
      filters(
        [
          { comment: [%r{http://centos.osuosl.org}, '#', ''] },
          { comment: [/^mirrorlist.*repo=os.*/, '#', ''] },
          { replace: [%r{^#baseurl=.*/os/}, "baseurl=#{centos_url}/$releasever/os/#{base_arch}/"] },
          { comment: [/^mirrorlist.*repo=updates.*/, '#', ''] },
          { replace: [%r{^#baseurl=.*/updates/}, "baseurl=#{centos_url}/$releasever/updates/#{base_arch}/"] },
          { comment: [/^mirrorlist.*repo=extras.*/, '#', ''] },
          { replace: [%r{^#baseurl=.*/extras/}, "baseurl=#{centos_url}/$releasever/extras/#{base_arch}/"] },
        ]
      )
      sensitive false
      notifies :run, 'execute[yum makecache]', :immediately
    end

    execute 'yum makecache' do
      action :nothing
    end

    package 'epel-release' do
      notifies :run, 'execute[import epel key]', :immediately
    end

    execute 'import epel key' do
      command 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7'
      action :nothing
    end

    filter_lines '/etc/yum.repos.d/epel.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-\$releasever.*/, '#', ''] },
          { replace: [
              /^#baseurl=.*basearch$/,
              'baseurl=https://epel.osuosl.org/$releasever/$basearch/',
            ],
          },
        ]
      )
      sensitive false
      notifies :run, 'execute[yum makecache]', :immediately
    end
  elsif centos_stream_platform?
    case node['platform_version'].to_i
    when 8
      filter_lines '/etc/yum.repos.d/CentOS-Stream-AppStream.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/AppStream/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-BaseOS.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/BaseOS/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-Extras.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/extras/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-HighAvailability.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/HighAvailability/$basearch/os/'] },
          ]
        )
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-PowerTools.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/PowerTools/$basearch/os/'] },
            { replace: [/^enabled=0$/, 'enabled=1'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-RealTime.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/RT/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/CentOS-Stream-ResilientStorage.repo' do
        filters(
          [
            { comment: [/^mirrorlist.*/, '#', ''] },
            { replace: [/^#baseurl.*/, 'baseurl=https://centos.osuosl.org/$stream/ResilientStorage/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end
    when 9
      filter_lines '/etc/yum.repos.d/centos.repo' do
        filters(
          [
            {
              replace: [
                /^metalink.*repo=centos-baseos-\$stream/,
                'baseurl=https://centos-stream.osuosl.org/$stream/BaseOS/$basearch/os/',
              ],
            },
            {
              replace: [
                /^metalink.*repo=centos-appstream-\$stream/,
                'baseurl=https://centos-stream.osuosl.org/$stream/AppStream/$basearch/os/',
              ],
            },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/centos-addons.repo' do
        filters(
          [
            {
              replace: [
                /^metalink.*repo=centos-extras-sig-extras-common-\$stream/,
                'baseurl=https://centos-stream.osuosl.org/SIGs/$stream/extras/$basearch/extras-common/',
              ],
            },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end
    end

    execute 'dnf makecache' do
      action :nothing
    end

    package %w(epel-release epel-next-release) do
      notifies :run, 'execute[import epel key]', :immediately
    end

    execute 'import epel key' do
      command "rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
      action :nothing
    end

    filter_lines '/etc/yum.repos.d/epel.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-\$releasever.*/, '#', ''] },
          { replace: [
              %r{^#baseurl=.*basearch/?$},
              'baseurl=https://epel.osuosl.org/$releasever/Everything/$basearch/',
            ],
          },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end

    filter_lines '/etc/yum.repos.d/epel-next.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-next-8.*/, '#', ''] },
          { comment: [/^metalink.*repo=epel-next-\$releasever.*/, '#', ''] },
          { replace: [
              %r{^#baseurl=.*basearch/$},
              'baseurl=https://epel.osuosl.org/next/$releasever/Everything/$basearch/',
            ],
          },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end
  elsif platform?('almalinux')
    case node['platform_version'].to_i
    when 8
      filter_lines '/etc/yum.repos.d/almalinux.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/baseos$}, '#', ''] },
            { replace: [%r{^# baseurl.*/BaseOS.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/BaseOS/$basearch/os/'] },
            { comment: [%r{^mirrorlist.*/appstream$}, '#', ''] },
            { replace: [%r{^# baseurl.*/AppStream.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/AppStream/$basearch/os/'] },
            { comment: [%r{^mirrorlist.*/extras$}, '#', ''] },
            { replace: [%r{^# baseurl.*/extras.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/extras/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/almalinux-powertools.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/powertools$}, '#', ''] },
            { replace: [%r{^# baseurl.*/PowerTools.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/PowerTools/$basearch/os/'] },
            { replace: [/^enabled=0$/, 'enabled=1'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end
    when 9
      filter_lines '/etc/yum.repos.d/almalinux-baseos.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/baseos$}, '#', ''] },
            { replace: [%r{^# baseurl.*/BaseOS.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/BaseOS/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/almalinux-appstream.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/appstream$}, '#', ''] },
            { replace: [%r{^# baseurl.*/AppStream.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/AppStream/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/almalinux-extras.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/extras$}, '#', ''] },
            { replace: [%r{^# baseurl.*/extras.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/extras/$basearch/os/'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end

      filter_lines '/etc/yum.repos.d/almalinux-crb.repo' do
        filters(
          [
            { comment: [%r{^mirrorlist.*/crb$}, '#', ''] },
            { replace: [%r{^# baseurl.*/CRB.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/CRB/$basearch/os/'] },
            { replace: [/^enabled=0$/, 'enabled=1'] },
          ]
        )
        sensitive false
        notifies :run, 'execute[dnf makecache]', :immediately
      end
    end

    filter_lines '/etc/yum.repos.d/almalinux-ha.repo' do
      filters(
        [
          { comment: [%r{^mirrorlist.*/ha$}, '#', ''] },
          { replace: [%r{^# baseurl.*/HighAvailability.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/HighAvailability/$basearch/os/'] },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end

    filter_lines '/etc/yum.repos.d/almalinux-rt.repo' do
      filters(
        [
          { comment: [%r{^mirrorlist.*/rt$}, '#', ''] },
          { replace: [%r{^# baseurl.*/RT.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/RT/$basearch/os/'] },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end

    filter_lines '/etc/yum.repos.d/almalinux-resilientstorage.repo' do
      filters(
        [
          { comment: [%r{^mirrorlist.*/resilientstorage$}, '#', ''] },
          { replace: [%r{^# baseurl.*/ResilientStorage.*/os/$}, 'baseurl=https://almalinux.osuosl.org/$releasever/ResilientStorage/$basearch/os/'] },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end

    execute 'dnf makecache' do
      action :nothing
    end

    package 'epel-release' do
      notifies :run, 'execute[import epel key]', :immediately
    end

    execute 'import epel key' do
      command "rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-#{node['platform_version'].to_i}"
      action :nothing
    end

    filter_lines '/etc/yum.repos.d/epel.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-\$releasever.*/, '#', ''] },
          { replace: [
              %r{^#baseurl=.*basearch/?$},
              'baseurl=https://epel.osuosl.org/$releasever/Everything/$basearch/',
            ],
          },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end
  end

  if node['platform_version'].to_i >= 8
    package 'dnf-automatic'

    service 'dnf-automatic-install.timer' do
      if node['osl-unmanaged']['packer']
        action [:disable, :stop]
      else
        action [:enable, :stop]
      end
    end
  else
    package 'yum-cron'

    service 'yum-cron' do
      if node['osl-unmanaged']['packer']
        action [:disable, :stop]
      else
        action [:enable, :stop]
      end
    end
  end
elsif platform_family?('debian')
  package %w(
    apt-transport-https
    dirmngr
    gnupg
    unattended-upgrades
  )

  filter_lines '/etc/apt/apt.conf.d/50unattended-upgrades' do
    filters(
      [
        # Ubuntu
        { after: [/-infra-security/, "\t\"${distro_id}:${distro_codename}-updates\";"] },
        # Debian
        { after: [/-security,label=Debian-Security/, "\t\"origin=Debian,codename=${distro_codename}-updates\";"] },
      ]
    )
    sensitive false
  end

  service 'unattended-upgrades.service' do
    if node['osl-unmanaged']['packer']
      action [:disable, :stop]
    else
      action [:enable, :stop]
    end
  end

  service 'apt-daily-upgrade.timer' do
    if node['osl-unmanaged']['packer']
      action [:disable, :stop]
    else
      action [:enable, :stop]
    end
  end

  if platform?('ubuntu')
    filter_lines '/etc/apt/sources.list' do
      filters(
        [
          { substitute: [
              %r{^deb http://.*ubuntu.com/ubuntu/?\s},
              %r{http://.*ubuntu.com/ubuntu/?\s},
              'https://ubuntu.osuosl.org/ubuntu ',
            ],
          },
          { substitute: [
              %r{^deb https://.*ubuntu.com/ubuntu/?\s},
              %r{https://.*ubuntu.com/ubuntu/?\s},
              'https://ubuntu.osuosl.org/ubuntu ',
            ],
          },
          { substitute: [
              %r{^deb http://ubuntu.osuosl.org/ubuntu/?\s},
              %r{http://ubuntu.osuosl.org/ubuntu/?\s},
              'https://ubuntu.osuosl.org/ubuntu ',
            ],
          },
          { substitute: [
              %r{^deb https://ubuntu.osuosl.org/ubuntu/\s},
              %r{https://ubuntu.osuosl.org/ubuntu/\s},
              'https://ubuntu.osuosl.org/ubuntu ',
            ],
          },
          { substitute: [
              %r{^deb http://ports.ubuntu.com/ubuntu-ports/\s},
              %r{http://ports.ubuntu.com/ubuntu-ports/\s},
              'http://ports.ubuntu.com/ubuntu-ports ',
            ],
          },
        ]
      )
      sensitive false
      notifies :update, 'apt_update[osl-unmanaged]', :immediately
    end
    filter_lines '/etc/apt/sources.list.d/ubuntu.sources' do
      if node['kernel']['machine'] == 'x86_64'
        filters(
          [
            { substitute: [
                %r{^URIs: http://.*ubuntu.com/ubuntu/?},
                %r{http://.*ubuntu.com/ubuntu/?},
                'https://ubuntu.osuosl.org/ubuntu',
              ],
            },
            { substitute: [
                %r{^URIs: https://.*ubuntu.com/ubuntu/?},
                %r{https://.*ubuntu.com/ubuntu/?},
                'https://ubuntu.osuosl.org/ubuntu',
              ],
            },
          ]
        )
      else
        filters(
          [
            { substitute: [
                %r{^URIs: http://ports.ubuntu.com/ubuntu-ports/?},
                %r{http://ports.ubuntu.com/ubuntu-ports/},
                'http://ports.ubuntu.com/ubuntu-ports',
              ],
            },
          ]
        )
      end
      sensitive false
      notifies :update, 'apt_update[osl-unmanaged]', :immediately
    end
  elsif platform?('debian')
    filter_lines '/etc/apt/sources.list' do
      filters(
        [
          { substitute: [
              %r{^deb https?://deb.debian.org/debian\s},
              %r{https?://deb.debian.org/debian/?\s},
              'https://debian.osuosl.org/debian ',
            ],
          },
          { substitute: [
              %r{^deb http://debian.osuosl.org/debian},
              %r{http://debian.osuosl.org/debian/?\s},
              'https://debian.osuosl.org/debian ',
            ],
          },
          { substitute: [
              %r{^deb https://debian.osuosl.org/debian},
              %r{https://debian.osuosl.org/debian/\s},
              'https://debian.osuosl.org/debian ',
            ],
          },
          { substitute: [
              %r{^deb https?://security.debian.org/debian-security\s},
              %r{https?://security.debian.org/debian-security/?\s},
              'https://deb.debian.org/debian-security ',
            ],
          },
          { substitute: [
              %r{^deb http://deb.debian.org/debian-security\s},
              %r{http://deb.debian.org/debian-security/?\s},
              'https://deb.debian.org/debian-security ',
            ],
          },
        ]
      )
      sensitive false
      notifies :update, 'apt_update[osl-unmanaged]', :immediately
    end
  end

  apt_update 'osl-unmanaged' do
    action :nothing
  end
end

directory '/usr/local/libexec'

template '/usr/local/libexec/firstboot.sh' do
  mode '0755'
end

systemd_unit 'osuosl-firstboot.service' do
  content <<~EOU
    [Unit]
    Description=OSUOSL First Boot script /usr/local/libexec/firstboot.sh
    After=network-online.target
    Wants=network-online.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/libexec/firstboot.sh

    [Install]
    WantedBy=multi-user.target
  EOU
  action [:create, :enable]
end
