# setting up https://github.com/calmh/syncthing
class backup::syncthing($repos=[]) {

  $version = 'v0.8.17'

  case $::operatingsystem {
      'FreeBSD': {
        $sum ='6d8fd2751e6eecad68dcc6db68b44c86'
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
        $sum = 'a04002d8abce148e504147550b81df60'
        $target = '/opt'
        $group = 'root'
        include backup::syncthing::ubuntu
      }

      default: {fail('no macthing os found')}
  }

  $url = "https://github.com/calmh/syncthing/releases/download/${version}/${release}.tar.gz"

  archive {"syncthing-${version}":
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

  file{["${target}/syncthing-${version}/.config",
        "${target}/syncthing-${version}/.config/syncthing"]:
    ensure  => directory,
    require => Archive["syncthing-${version}"]
  } ->

  file { "${target}/syncthing-${version}/.config/syncthing/config.xml":
    ensure  => file,
    mode    => 'u+rw',
    content => template('backup/config.xml.erb'),
    owner   => root,
    group   => $group,
    require => Archive["syncthing-${version}"]
  } ~> Service['syncthing']
}
