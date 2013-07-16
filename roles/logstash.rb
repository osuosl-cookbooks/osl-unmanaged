name "logstash_server"
description "Attributes and run_lists specific to FAO's logstash instance"
default_attributes(
  :logstash => {
    :kibana => {
        :http_port => "8080",
    },
    :server => {
      :enable_embedded_es => true,
      :inputs => [
        :syslog => {
          :type => "syslog",
          :port => "5000"
        }
      ],
      :allowed_ip_ranges => [
        "140.211.166.0/23",
        "10.1.0.0/24",
        "140.211.15.0/24"
      ],
      :filters => [
        :grok => {
          :type => "syslog",
          :pattern => "<%{POSINT:syslog_pri}>%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}",
          :patterns_dir => '/opt/logstash/server/etc/patterns/'
        }
      ],
      :outputs => [
        :file => {
          :type => 'syslog',
          :path => '/opt/logstash/server/syslog_logs/%{syslog_hostname}.log',
        }
      ]
    }
  }

)
run_list(
  "role[base_managed]",
  "recipe[logstash::server]",
  "recipe[php::module_curl]",
  "recipe[logstash::kibana]",
  "recipe[firewall::kibana]",
  "recipe[firewall::logstash-server]"
)
