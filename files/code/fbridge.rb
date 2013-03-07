#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require 'optparse'

options = {}
version = "0.1"

optparse = OptionParser.new do|opts|
  opts.banner = "Usage: fbridge.rb [options]"

  options[:debug] = false
  opts.on( '-d', '--debug', 'Much output.' ) do
    options[:debug] = true
  end

  options[:configfile] = "/etc/nsd3/code/config.yaml"
  opts.on( '-c', '--config FILE', 'Config is FILE' ) do|file|
    options[:configfile] = file
  end

  options[:servertype] = "master"
  opts.on( '-s', '--server MASTER|SLAVE', 'Server is TYPE' ) do|file|
    options[:servertype] = file
  end

  options[:zonelist] = "domain-list"
  opts.on( '-z', '--zonelist ZONES', 'list of ZONES' ) do|file|
    options[:zonelist] = file
  end
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
        exit
  end
end

optparse.parse!

if options[:debug]
  puts "DEBUG"
  puts "VERSION #{version}"
  puts "CONFIGFILE: #{options[:configfile]}"
end

yconfig = YAML.load_file(options[:configfile])

puts yconfig.inspect if options[:debug]

hfile = File.open(options[:zonelist])

hfile.each do |line|
  next if line =~ /^\#/
  line.chomp!
  fred,zonetype,zone = line.split(':',3)

  if options[:servertype] == 'master'

    case zonetype
      when 'M'
        puts "zone:\n\tname: \"#{zone}\"\n\tzonefile: \"master.#{zone}\"\n"
      when 'S'
        puts "zone:\n\tname: \"#{zone}\"\n\tzonefile: \"master.standard.zonefile\"\n"
      when 'F'
        puts "zone:\n\tname: \"#{zone}\"\n\tzonefile: \"master.standard.zonefile.fr\"\n"
    end

    yconfig['servers'].each do |sname,sdata|
      puts "\tnotify: #{sdata['address']} NOKEY\n\tprovide-xfr: #{sdata['address']} NOKEY\n\toutgoing-interface: #{sdata['outbound-addr']}\n\n"
    end
  else
    puts "zone:\n\tname: \"#{zone}\"\n\tzonefile: \"#{zone}.zone\"\n"

    yconfig['servers'].each do |sname,sdata|
      puts "\tallow-notify: #{sdata['address']} NOKEY\n\trequest-xfr: AXFR #{sdata['address']} NOKEY\n\toutgoing-interface: #{sdata['outbound-addr']}\n\n"
    end
  end
end
