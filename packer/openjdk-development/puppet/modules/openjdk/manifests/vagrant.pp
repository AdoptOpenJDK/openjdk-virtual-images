class openjdk::vagrant {

  $vagrant_key = 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
  $auth_keys   = '/home/vagrant/.ssh/authorized_keys'

  File {
    owner  => 'vagrant',
    group  => 'vagrant',
  }

  file { '/home/vagrant/.ssh': ensure => directory, }
  file { $auth_keys:           ensure => file, mode => '0600', }

  exec { 'download-vagrant-key':
    command => "/usr/bin/wget --no-check-certificate ${vagrant_key} -O ${auth_keys}",
    user    => 'vagrant',
  }

}
