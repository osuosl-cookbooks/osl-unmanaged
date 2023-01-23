#
# Cookbook:: osl-unmanaged
# Recipe:: repos
#
# Copyright:: 2022-2023, Oregon State University
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
if platform_family?('rhel')
  if centos_stream_platform?
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

    execute 'dnf makecache' do
      action :nothing
    end

    package %w(epel-release epel-next-release) do
      notifies :run, 'execute[import epel key]', :immediately
    end

    execute 'import epel key' do
      command 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8'
      action :nothing
    end

    filter_lines '/etc/yum.repos.d/epel.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-\$releasever.*/, '#', ''] },
          { replace: [
              /^#baseurl=.*basearch$/,
              'baseurl=https://epel.osuosl.org/$releasever/Everything/$basearch/',
            ],
          },
        ]
      )
      sensitive false
      notifies :run, 'execute[dnf makecache]', :immediately
    end

    filter_lines '/etc/yum.repos.d/epel-modular.repo' do
      filters(
        [
          { comment: [/^metalink.*repo=epel-modular-\$releasever.*/, '#', ''] },
          { replace: [
              /^#baseurl=.*basearch$/,
              'baseurl=https://epel.osuosl.org/$releasever/Modular/$basearch/',
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
  end

  package 'dnf-automatic'

  service 'dnf-automatic-install.timer' do
    if node['osl-unmanaged']['packer']
      action [:disable, :stop]
    else
      action [:enable, :stop]
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
