class openjdk::chef {
  package { 'chef':
    provider        => gem,
    require         => Class['openjdk::ruby'],
    install_options => [ '--no-ri', '--no-doc' ]
  }
}
