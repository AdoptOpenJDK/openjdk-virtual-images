class openjdk::sudo {

  group { 'admin': ensure  => present, }

  user { 'vagrant':
    ensure  => present,
    groups  => ['admin'],
    require => Group['admin'],
  }

  file  { '/etc/sudoers':
    source => 'puppet:///modules/openjdk/etc_sudoers',
    owner  => 'root',
    group  => 'root',
  }

}
