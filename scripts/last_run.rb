#!/usr/bin/env ruby

# Chef requires
require 'chef/knife'
require 'chef/knife/exec'
require 'chef/shell/ext'

# Other requires
require 'optparse'
require 'pry' # for a repl

# Parse options
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  opts.on('-n', '--never', "Display nodes that have never run") do |o|
    options[:never] = o
  end

  opts.on('-o', '--oldest', "Display nodes sorted from newest last run to oldest") do |o|
    options[:oldest] = o
  end

  opts.on('-t', '--not-today', "Display nodes that have not run today") do |o|
    options[:not_today] = o
  end

  opts.on('-d', '--debug', 'Drop into a repl after loading nodes') do |o|
    options[:debug] = o
  end

  opts.on('--no-ignore', 'Dont ignore nodes marked to be ignored') do |o|
    options[:no_ignore]
  end

end.parse!

# Helper functions that output useful stuff
def debug(nodes)
  binding.pry
end

def ignore()
end

def never(nodes)
  out = nodes.dup.keep_if {|n,t| !t }
  puts "\n\n"
  puts "the following nodes have never had a successful chef run:"
  puts out.keys.join("\n")
end

def oldest(nodes)
  out = nodes.dup 
  out.keep_if {|n,t| !!t}
  ns = out.to_a.sort { |a,b| b.last <=> a.last }
  puts "\n\n"
  puts "From newest run to oldest run:"
  puts ns.collect {|n| "#{n.first} #{Time.at(n.last)}"}.join("\n")
end

def not_today(nodes)
  out = nodes.dup.keep_if {|n,t| !!t and Time.now.to_i - t > 86400 }
  puts "\n\n"
  puts "the following nodes have not run successfully in the last 24 hours:"
  puts out.keys.join("\n")
end

# Collect ohai_time (time since last run, in epoch seconds) into ns
def main(options)
  ns = {}

  ignore = Proc.new { |n| !options[:no_ignore] and n[:last_run_ignore] }
  exec_block = Proc.new do |nodes|
    nodes.all do |n|
      ns[n.name] = n[:ohai_time] unless ignore.call(n)
    end
  end

  # We want a knife-like configuration, not a client style config
  k = Chef::Knife::Exec.new
  k.configure_chef

  # Generate context
  context = Object.new
  Shell::Extensions.extend_context_object(context)

  exec_block.call(context.nodes)
  return ns
end

# Collect nodes
ns = main options

# Run helper functions for output
options.each_pair do |k,v|
  self.send(k.to_sym, ns) if v
end
