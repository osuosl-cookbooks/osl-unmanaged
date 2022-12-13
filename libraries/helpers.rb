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
        if platform_family?('rhel')
          %w(openssh-server openssh-clients)
        else
          %w(openssh-server openssh-client)
        end
      end

      def openstack_pkgs
        pkgs = []
        if platform_family?('rhel')
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
        if platform_family?('rhel')
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

      def ibm_pkgs
        # https://www.ibm.com/docs/en/rsct/3.3?topic=installation-verifying-linux-nodes
        if platform_family?('rhel')
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
        if platform_family?('rhel')
          case node['kernel']['machine']
          when 'ppc64le'
            'GRUB_CMDLINE_LINUX="console=hvc0,115200n8 console=tty0 crashkernel=auto rhgb quiet"'
          else
            'GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 crashkernel=auto rhgb quiet"'
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
        elsif node['kernel']['machine'] == 'aarch64'
          'grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg'
        else
          'grub2-mkconfig -o /boot/grub2/grub.cfg'
        end
      end

      def powervs_grub_cmdline
        if platform_family?('rhel')
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
        if platform_family?('rhel')
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
            end
          end
        end
      end

      def chrony_conf
        if platform_family?('rhel')
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
        pkgs << 'megacli' if node['kernel']['modules'].key?('megaraid_sas') && platform_family?('debian')
        pkgs << 'mdadm' if node.key?('mdadm')
        pkgs
      end

      def mdadm_conf
        if platform_family?('rhel')
          '/etc/mdadm.conf'
        else
          '/etc/mdadm/mdadm.conf'
        end
      end
    end
  end
end
Chef::DSL::Recipe.include ::OslUnmanaged::Cookbook::Helpers
Chef::Resource.include ::OslUnmanaged::Cookbook::Helpers
