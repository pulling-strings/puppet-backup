# setting up https://github.com/calmh/syncthing
class backup::syncthing(
  $repos={},
  $nodes={},
  $user = 'vagrant',
  $password = '$2a$10$2V8KEPD0vkIqtxeZSikS3OljbZFs1mHf5XujeYBEg197Ht7ua5XA2',
  $token = ''
) {

  $version = 'v0.10.3'

  case $::operatingsystem {
      'FreeBSD': {
        $sum ='93b7f064a059f7581fbb2fea44230a56'
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
        $sum = 'f5209a4076e1b75368165094c575f392'
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
