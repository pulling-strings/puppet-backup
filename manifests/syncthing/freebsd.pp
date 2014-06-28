# Freebsd syncthing setup
class backup::syncthing::freebsd($version=false,$release=false) {
  validate_string($version)
  validate_string($release)
  Package {
    provider => pkgng
  }

  notice($version)
  file { '/etc/rc.d/syncthing':
    ensure  => file,
    mode    => 'u+x',
    content => template('backup/syncthing.rc.erb'),
    owner   => root,
    group   => wheel,
  } ->

  file_line { 'enable syncthing':
    path => '/etc/rc.conf',
    line => 'syncthing_enable="YES"'
  } ~> Service['syncthing']
}
