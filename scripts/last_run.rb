#!/usr/bin/env ruby

# Chef requires
require 'chef/knife'
require 'chef/knife/exec'
require 'chef/shell/ext'

# Other requires
require 'optparse'

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

end.parse!

# Helper functions that output useful stuff
def never(nodes)
  out = nodes.dup.keep_if {|n,t| !t }
  puts "the following nodes have never had a successful chef run:"
  puts out.keys.join("\n")
  puts "\n\n"
end

def oldest(nodes)
  out = nodes.dup 
  out.keep_if {|n,t| !!t}
  ns = out.to_a.sort { |a,b| b.last <=> a.last }
  puts "From newest run to oldest run:"
  puts ns.collect {|n| "#{n.first} #{Time.at(n.last)}"}.join("\n")
  puts "\n\n"
end

def not_today(nodes)
  out = nodes.dup.keep_if {|n,t| !!t and Time.now.to_i - t < 86400 }
  puts "the following nodes have not run successfully in the last 24 hours:"
  puts out.keys.join("\n")
  puts "\n\n"
end

# Collect ohai_time (time since last run, in epoch seconds) into ns
def main()
  ns = {}
  exec_block = Proc.new do |nodes|
    nodes.all do |n|
      ns[n.name] = n[:ohai_time]
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
ns = main

# Run helper functions for output
options.each_pair do |k,v|
  self.send(k.to_sym, ns) if v
end
