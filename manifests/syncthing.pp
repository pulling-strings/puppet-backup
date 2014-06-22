# setting up https://github.com/calmh/syncthing
class backup::syncthing($repos=[]) {
  $version = 'v0.8.15'
  $release = "syncthing-linux-amd64-${version}"
  $url = "https://github.com/calmh/syncthing/releases/download/${version}/${release}.tar.gz"

  archive {'syncthing':
    ensure     => present,
    url        => $url,
    checksum   => false,
    src_target => '/usr/src/',
    target     => '/opt/',
    extension  => 'tar.gz',
  }

  file { '/etc/init/syncthing.conf':
    ensure  => file,
    mode    => 'u+x',
    content => template('backup/syncthing.erb'),
    owner   => root,
    group   => root,
  } ->

  file{'/etc/init.d/syncthing':
    ensure => link,
    target => '/etc/init/syncthing',
    mode   => 'a+x',
  } ->

  service{'syncthing':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  file{['/opt/syncthing/.config','/opt/syncthing/.config/syncthing']:
    ensure => directory,
    require => Archive['syncthing']
  } ->

  file { '/opt/syncthing/.config/syncthing/config.xml':
    ensure  => file,
    mode    => 'u+rw',
    content => template('backup/config.xml.erb'),
    owner   => root,
    group   => root,
    require => Archive['syncthing']
  } ~> Service['syncthing']
}
