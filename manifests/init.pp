# == Class: nsd3
#
# Manage NSD3 master and slave DNS servers.
#
# Prerequisite - a version-controlled repository of zonefiles
# in bind or NSD format.
#
# === Parameters
#
# None.
#
# === Variables
#
# nsd3::servertype:
#
# 'master' or 'slave'
#
# === Examples
#
# include nsd3
#
# In relevant part of hiera tree - nsd3::servertype: master
#
# === Authors
#
# John Hawkes-Reed <john.hawkes-reed@futurenet.com> / <jhr@mysparedomain.com>
#
# === Copyright
#
# Copyright 2012 John Hawkes-Reed, unless otherwise noted.
#

class nsd3 {
  anchor { 'nsd3::start': } ->
  class { 'nsd3::package': } ~>
  class { 'nsd3::config': } ~>
  class { 'nsd3::service': } ~>
  anchor { 'nsd3::end': }
}
