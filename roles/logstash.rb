name "logstash_server"
description "Attributes and run_lists specific to FAO's logstash instance"
default_attributes(
  :logstash => {
    :server => {
      :enable_embedded_es => true,
      :inputs => [
        :syslog => {
          :type => "syslog",
        }
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
  "role[base]",
  "recipe[logstash::server]",
  "recipe[php::module_curl]",
  "recipe[logstash::kibana]"
)

