module OslUnmanaged
  module Cookbook
    module Helpers
      def unmanaged_sshd_config
        {
          'ChallengeResponseAuthentication' => 'no',
          'Ciphers' => 'chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr',
          'ClientAliveInterval' => '60',
          'GSSAPIAuthentication' => 'no',
          'HostKeyAlgorithms' => '+ssh-rsa',
          'KbdInteractiveAuthentication' => 'no',
          'KexAlgorithms' => 'curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256',
          'PasswordAuthentication' => 'no',
          'PermitRootLogin' => 'prohibit-password',
          'PubkeyAcceptedKeyTypes' => '+ssh-rsa',
          'UseDNS' => 'no',
        }
      end

      def ifcfg_files
        Dir['/etc/sysconfig/network-scripts/ifcfg-*'].reject { |f| File.basename(f).match('ifcfg-lo') }
      end

      def openssh_pkgs
        if platform_family?('rhel', 'fedora')
          %w(openssh-server openssh-clients)
        else
          %w(openssh-server openssh-client)
        end
      end

      def epel_pkgs
        if centos_stream_platform? && node['platform_version'].to_i < 10
          %w(epel-release epel-next-release)
        else
          'epel-release'
        end
      end

      def openssh_service
        if platform?('ubuntu') && node['platform_version'].to_f == 24.04
          'ssh'
        else
          'sshd'
        end
      end

      def openstack_pkgs
        pkgs = []
        if platform_family?('rhel', 'fedora')
          pkgs = %w(
            cloud-init
            cloud-utils-growpart
            gdisk
          )
          pkgs << 'ppc64-diag' if node['kernel']['machine'] == 'ppc64le'
        else
          pkgs = %w(
            cloud-utils
            cloud-init
            cloud-initramfs-growroot
          )
          pkgs << 'powerpc-utils' if node['kernel']['machine'] == 'ppc64le'
        end
        pkgs.sort
      end

      def powervs_pkgs
        if platform_family?('rhel', 'fedora')
          %w(
            cloud-init
            cloud-utils-growpart
            device-mapper-multipath
          )
        else
          %w(
            cloud-guest-utils
            cloud-init
            multipath-tools
            multipath-tools-boot
          )
        end
      end

      def ibm_yum_repo_url
        if platform_family?('fedora')
          'https://public.dhe.ibm.com/software/server/POWER/Linux/yum/OSS/Fedora/$basearch'
        else
          'https://public.dhe.ibm.com/software/server/POWER/Linux/yum/OSS/RHEL/$releasever/$basearch'
        end
      end

      def ibm_pkgs
        # https://www.ibm.com/docs/en/rsct/3.3?topic=installation-verifying-linux-nodes
        if platform_family?('rhel', 'fedora')
          %w(
            rsct.basic
            rsct.core
            src
          )
        else
          %w(
            rsct.core
            rsct.core.utils
            src
          )
        end
      end

      def openstack_grub_cmdline
        if platform_family?('rhel', 'fedora')
          if node['platform_version'].to_i >= 9
            'GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 no_timer_check"'
          else
            case node['kernel']['machine']
            when 'ppc64le'
              'GRUB_CMDLINE_LINUX="console=hvc0,115200n8 console=tty0 crashkernel=auto rhgb quiet"'
            else
              'GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 crashkernel=auto rhgb quiet"'
            end
          end
        else
          case node['kernel']['machine']
          when 'ppc64le'
            'GRUB_CMDLINE_LINUX="console=hvc0,115200n8 console=tty0"'
          else
            'GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0"'
          end
        end
      end

      def openstack_grub_mkconfig
        if docker?
          'true'
        elsif platform_family?('debian')
          'update-grub'
        elsif node['kernel']['machine'] == 'aarch64' && el? && node['platform_version'] >= 10
          'grub2-mkconfig -o /boot/grub2/grub.cfg'
        elsif node['kernel']['machine'] == 'aarch64'
          "grub2-mkconfig -o /boot/efi/EFI/#{node['platform']}/grub.cfg"
        else
          'grub2-mkconfig -o /boot/grub2/grub.cfg'
        end
      end

      def powervs_grub_cmdline
        if platform_family?('rhel', 'fedora')
          case node['kernel']['machine']
          when 'ppc64le'
            'GRUB_CMDLINE_LINUX="console=tty0 console=hvc0,115200n8 crashkernel=auto rd.shell rd.driver.pre=dm_multipath log_buf_len=1M"'
          else
            'GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200n8 crashkernel=auto rd.shell rd.driver.pre=dm_multipath log_buf_len=1M"'
          end
        else
          case node['kernel']['machine']
          when 'ppc64le'
            'GRUB_CMDLINE_LINUX="console=tty0 console=hvc0,115200n8"'
          else
            'GRUB_CMDLINE_LINUX="console=tty0 console=ttyS0,115200n8"'
          end
        end
      end

      def powervs_modules
        %w(
          ibmveth
          ibmvfc
          ibmvscsi
          pseries_rng
          rpadlpar_io
          rpaphp
          scsi_dh_alua
          scsi_dh_emc
          scsi_dh_rdac
          scsi_transport_fc
          scsi_transport_srp
        )
      end

      def cleanup_pkgs
        if platform_family?('rhel', 'fedora')
          %w(gcc cpp kernel-devel kernel-headers)
        elsif platform_family?('debian')
          if platform?('debian')
            case node['platform_version']
            when '11'
              %w(
                build-essential
                command-not-found
                friendly-recovery
                gcc
                g++
                installation-report
                laptop-detect
                libc6-dev
                libx11-6
                libx11-data
                libxcb1
                libxext6
                libxmuu1
                make
                popularity-contest
                ppp
                pppconfig
                pppoeconf
                wireless-regdb
                xauth
              )
            when '12'
              %w(
                build-essential
                command-not-found
                friendly-recovery
                gcc
                g++
                installation-report
                laptop-detect
                libc6-dev
                libx11-6
                libx11-data
                libxcb1
                libxext6
                libxmuu1
                make
                popularity-contest
                ppp
                pppconfig
                pppoeconf
                wireless-regdb
                xauth
              )
            end
          elsif platform?('ubuntu')
            case node['platform_version']
            when '20.04'
              %w(
                build-essential
                command-not-found
                fonts-ubuntu-console
                fonts-ubuntu-font-family-console
                friendly-recovery
                gcc
                g++
                installation-report
                landscape-common
                laptop-detect
                libc6-dev
                libx11-6
                libx11-data
                libxcb1
                libxext6
                libxmuu1
                make
                popularity-contest
                ppp
                pppconfig
                pppoeconf
                xauth
              )
            when '22.04'
              %w(
                build-essential
                command-not-found
                fonts-ubuntu-console
                friendly-recovery
                gcc
                g++
                landscape-common
                laptop-detect
                libc6-dev
                libx11-6
                libx11-data
                libxcb1
                libxext6
                libxmuu1
                make
                popularity-contest
                ppp
                pppconfig
                pppoeconf
                xauth
              )
            when '24.04'
              %w(
                build-essential
                command-not-found
                fonts-ubuntu-console
                friendly-recovery
                gcc
                g++
                landscape-common
                laptop-detect
                libc6-dev
                libx11-6
                libx11-data
                libxcb1
                libxext6
                libxmuu1
                make
                popularity-contest
                ppp
                pppconfig
                pppoeconf
                xauth
              )
            end
          end
        end
      end

      def chrony_conf
        if platform_family?('rhel', 'fedora')
          '/etc/chrony.conf'
        else
          '/etc/chrony/chrony.conf'
        end
      end

      def apt_reinstall_pkgs
        require 'mixlib/shellout'

        reinstall_pkgs = Mixlib::ShellOut.new('dpkg-query -S /lib/firmware')
        reinstall_pkgs.run_command
        reinstall_pkgs.error!
        pkgs = reinstall_pkgs.stdout.gsub(/:.*/, '').split(',').chomp
        pkgs.delete('wireless-regdb')
        pkgs
      rescue
        []
      end

      def raid_pkg
        pkgs = []
        pkgs << 'megacli' if node['kernel']['modules'].key?('megaraid_sas')
        pkgs << 'mdadm' if node.key?('mdadm')
        pkgs
      end

      def mdadm_conf
        if platform_family?('rhel', 'fedora')
          '/etc/mdadm.conf'
        else
          '/etc/mdadm/mdadm.conf'
        end
      end

      def fail2ban_pkgs
        case node['platform_family']
        when 'fedora'
          %w(fail2ban iptables-legacy)
        when 'rhel'
          case node['platform_version'].to_i
          when 10
            %w(fail2ban iptables-nft-services)
          when 9
            %w(fail2ban iptables-legacy)
          else
            %w(fail2ban iptables)
          end
        else
          %w(fail2ban iptables)
        end
      end

      def network_pkgs
        case node['platform_family']
        when 'fedora'
          %w(dhcp-client NetworkManager)
        when 'rhel'
          case node['platform_version'].to_i
          when 10
            %w(dhcpcd NetworkManager)
          when 9, 8
            %w(dhcp-client NetworkManager)
          else
            %w(dhclient NetworkManager)
          end
        when 'debian'
          %w(network-manager isc-dhcp-client netplan.io)
        end
      end

      def centos_url
        case node['kernel']['machine']
        when 'aarch64', 'ppc64le'
          'https://centos-altarch.osuosl.org'
        else
          'https://centos.osuosl.org'
        end
      end

      def base_arch
        if node['cpu']['model_name'].match?(/POWER9/)
          'power9'
        else
          '$basearch'
        end
      end

      def rsct_enabled
        if node['cpu']['model_name']
          node['cpu']['model_name'].match(/POWER10/)
        else
          false
        end
      end
    end
  end
end
Chef::DSL::Recipe.include ::OslUnmanaged::Cookbook::Helpers
Chef::Resource.include ::OslUnmanaged::Cookbook::Helpers
