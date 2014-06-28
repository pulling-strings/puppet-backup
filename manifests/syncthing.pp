# setting up https://github.com/calmh/syncthing
class backup::syncthing($repos=[]) {
  case $::operatingsystem {
      'FreeBSD': {
        $os = 'freebsd'
        $sum ='6d8fd2751e6eecad68dcc6db68b44c86'
        $target = '/usr/local'
        Package {
          provider => pkgng
        }
      }
      'Ubuntu': {
        $os = 'linux'
        $sum = 'a04002d8abce148e504147550b81df60'
        $target = '/opt'
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
        } -> Service['syncthing']
      }
      default: {fail('no macthing os found')}
  }

  $version = 'v0.8.17'
  $release = "syncthing-${os}-amd64-${version}"
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

  file{["${target}/syncthing-${version}/.config","${target}/syncthing-${version}/.config/syncthing"]:
    ensure  => directory,
    require => Archive["syncthing-${version}"]
  } ->

  file { "${target}/syncthing-${version}/.config/syncthing/config.xml":
    ensure  => file,
    mode    => 'u+rw',
    content => template('backup/config.xml.erb'),
    owner   => root,
    group   => root,
    require => Archive["syncthing-${version}"]
  } ~> Service['syncthing']
}
