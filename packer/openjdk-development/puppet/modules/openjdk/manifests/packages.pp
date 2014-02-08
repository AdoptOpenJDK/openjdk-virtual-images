class openjdk::packages {
  include openjdk::packages::update

  $packages = [
    'build-essential',
    'ccache',
    'dkms',
    'libX11-dev',
    'libasound2-dev',
    'libcups2-dev',
    'libfreetype6-dev',
    'libreadline-gplv2-dev',
    'libssl-dev',
    'libxext-dev',
    'libxrender-dev',
    'libxt-dev',
    'libxtst-dev',
    'libyaml-dev',
    "linux-headers-${::kernelrelease}",
    'mercurial',
    'nfs-common',
    'openjdk-7-jdk',
    'unzip',
    'vim',
    'zip',
    'zlib1g-dev',
  ]

  package { $packages: ensure => latest }
}

class openjdk::packages::update {
  exec { 'update and upgrade':
    command => '/usr/bin/apt-get -y update && /usr/bin/apt-get -y upgrade'
  }
}
