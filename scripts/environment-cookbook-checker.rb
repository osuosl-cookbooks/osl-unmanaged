#!/usr/bin/env ruby

# Chef requirements
require 'chef'
require 'chef/knife'

# Other requirements
require 'optparse'
require 'pry'
require 'json'

# set default options
options = {
  'environment' => 'production',
  'environment_file' => ''
}

OptionParser.new do |opts|
  opts.banner = "Usage: environment-cookbook-checker.rb [options]"

  opts.on('-E ENV', '--environment=ENV', String) do |v|
    options['environment'] = v
  end
  opts.on('-f FILE', '--env-file FILE', String) do |v|
    options['environment_file'] = v
  end
end.parse!

def configure_chef
  k = Chef::Knife.new
  k.configure_chef
end

def get_env_cookbooks(env)
  configure_chef
  return Chef::Environment.load(env).cookbook_versions
end

def get_env_cookbooks_json(file)
  configure_chef
  begin
    json = File.open(file, 'r').read
  rescue Errno::ENOENT
    puts "Unable to find file #{file}"
    exit 1
  end
  env = JSON.parse(json)
  return env['cookbook_versions']
end
  
def find_broken_cookbooks(cookbook_versions)
  broken_cookbooks = []
  cookbook_versions.each_pair do |cb, constraint|
    versions = Chef::CookbookVersion.available_versions(cb)
    spec = Chef::VersionConstraint.new(constraint)
    broken_cookbooks << cb unless versions.any? { |v| spec.include?(v) }
  end
  return broken_cookbooks
end

def report_broken_cookbooks(broken_cookbooks)
  case broken_cookbooks.empty?
  when true
    exit 0
  when false
    puts "The following cookbooks do not have versions that match their constraints:"
    puts broken_cookbooks.join("\n")
    exit 1
  end
end

case options['environment_file'].empty?
  when true
    env_cb = get_env_cookbooks(options['environment'])
  else
    env_cb = get_env_cookbooks_json(options['environment_file'])
end

report_broken_cookbooks(find_broken_cookbooks(env_cb))
