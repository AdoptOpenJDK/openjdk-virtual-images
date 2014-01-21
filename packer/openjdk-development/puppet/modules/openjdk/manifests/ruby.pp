class openjdk::ruby {

  $ruby = 'ruby2.0'

  package { [ $ruby, "${ruby}-dev", 'ruby-switch' ]: ensure => latest }

  exec { 'update-ruby-version':
    command => "/usr/bin/ruby-switch --set ${ruby}",
    require => Package[$ruby]
  }
}
