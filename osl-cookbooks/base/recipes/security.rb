case node['platform_family']
when "rhel"
  # Run yum security updates Sundays at 2am
  cron_d "yum-security" do
    minute  "0"
    hour    "9"
    weekday "0"
    mailto  "root@osuosl.org"
    shell   "/bin/bash"
    command "yum update --security -y"
  end
end
