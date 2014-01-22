class openjdk::packages {
  include openjdk::packages::update

  $packages = [
    "linux-headers-${::kernelrelease}",
    'build-essential',
    'zlib1g-dev',
    'libssl-dev',
    'libreadline-gplv2-dev',
    'libyaml-dev',
    'vim',
    'dkms',
    'nfs-common'
  ]

  package { $packages: ensure => latest }
}

class openjdk::packages::update {
  exec { 'update and upgrade':
    command => '/usr/bin/apt-get -y update && /usr/bin/apt-get -y upgrade'
  }
}
