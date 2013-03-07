class nsd3::config {

  $servertype = hiera('nsd3::servertype')

  file { '/etc/nsd3/code/':
    ensure  => directory,
    source  => 'puppet:///modules/nsd3/code/',
    recurse => true,
    owner   => nsd,
    group   => nsd,
    mode    => '0755',
  }

  file { '/etc/nsd3/code/domain-list':
    ensure  => present,
    source  => 'puppet:///modules/nsd3/code/domain-list',
    owner   => nsd,
    group   => nsd,
    mode    => '0444',
  }

  file { '/etc/nsd3/nsd.head':
    ensure  => present,
    owner   => nsd,
    group   => nsd,
    mode    => '0444',
    source  => "puppet:///modules/nsd3/${::hostname}-nsd.head",
  }

  file { '/etc/nsd3/code/config.yaml':
    ensure  => present,
    owner   => nsd,
    group   => nsd,
    mode    => '0444',
    source  => "puppet:///modules/nsd3/${nsd3::config::servertype}.yaml",
  }

  file { '/var/lib/nsd3/.git/HEAD':
    audit   => content,
    notify  => Exec['rebuild'],
  }

  exec { 'rebuild':
    command     => '/etc/nsd3/code/refresh.sh',
    refreshonly => true,
  }

  exec { 'buildzones':
    command     => "/etc/nsd3/code/generate-zone-config.sh -t ${nsd3::config::servertype}",
    subscribe   => File['/etc/nsd3/code/domain-list'],
    refreshonly => true,
  }
}
