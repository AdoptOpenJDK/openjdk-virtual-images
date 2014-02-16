# = Class: eclipse
#
# Manage Eclipse through Puppet
#
# == Parameters:
#
# == Actions:
#   Install Eclipse Kepler
#
# == Requires:
#   - Module['Archive']
class openjdk::eclipse {
    $release = "eclipse-jee-kepler-SR1-linux-gtk-x86_64"
    $baseUrl = "http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/kepler/SR1/"

    archive { $release:
    ensure     => present,
    timeout    => 7200,
    url        => "${baseUrl}${release}.tar.gz",
    checksum   => false,
    src_target => '/usr/src',
    target     => '/opt',
    extension  => 'tar.gz',
  }

  file { "/opt/eclipse":
    ensure  => link,
    target  => "/opt/${release}",
    require => Archive[$release],
  }
}
