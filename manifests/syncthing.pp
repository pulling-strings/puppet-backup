# setting up https://github.com/calmh/syncthing
class backup::syncthing(
  $repos={},
  $nodes={},
  $user = 'vagrant',
  $password = '$2a$10$2V8KEPD0vkIqtxeZSikS3OljbZFs1mHf5XujeYBEg197Ht7ua5XA2'
) {

  $version = 'v0.9.9'

  case $::operatingsystem {
      'FreeBSD': {
        $sum ='cdd03491123a9d342500b5a1d2158f15'
        $target = '/usr/local'
        $release = "syncthing-freebsd-amd64-${version}"
        class{'backup::syncthing::freebsd':
          version => $backup::syncthing::version,
          release => $backup::syncthing::release
        }
      }

      'Ubuntu': {
        $os = 'linux'
        $release = "syncthing-linux-amd64-${version}"
        $sum = '58f276046946af7d19462c23e1a87f1d'
        $target = '/opt'
        $group = 'root'
        include backup::syncthing::ubuntu
      }

      default: {fail('no macthing os found')}
  }

  $url = "https://github.com/syncthing/syncthing/releases/download/${version}/${release}.tar.gz"

  archive {'syncthing':
    ensure        => present,
    url           => $url,
    digest_string => $sum,
    src_target    => '/usr/src',
    target        => $target,
    extension     => 'tar.gz',
  }

  service{'syncthing':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  file{["${target}/syncthing/.config",
        "${target}/syncthing/.config/syncthing"]:
    ensure  => directory,
    require => Archive['syncthing']
  } ->

  file { "${target}/syncthing/.config/syncthing/config.xml":
    ensure  => file,
    mode    => 'u+rw',
    content => template('backup/config.xml.erb'),
    owner   => root,
    group   => $group,
    require => Archive['syncthing']
  } ~> Service['syncthing']
}
