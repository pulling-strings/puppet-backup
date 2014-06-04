# setting up https://github.com/calmh/syncthing
class backup::syncthing {
  
  $version = 'v0.8.12'
  $release = "syncthing-linux-amd64-${version}"
  $url = "https://github.com/calmh/syncthing/releases/download/v0.8.12/${release}.tar.gz"

  archive {'syncthing':
    ensure     => present,
    url        => $url,
    checksum   => false,
    src_target => '/usr/src/',
    target     => '/opt/',
    extension  => 'tar.gz',
  }
  
  file { '/etc/init/syncthing.conf':
    ensure=> file,
    mode  => 'u+x',
    content => template('backup/syncthing.erb'),
    owner => root,
    group => root,
  } ->

  service{'syncthing':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

}
