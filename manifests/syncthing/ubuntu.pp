# Ubuntu Syncthing setup
class backup::syncthing::ubuntu {

  file { '/etc/init/syncthing.conf':
    ensure  => file,
    mode    => 'u+x',
    content => template('backup/syncthing.erb'),
    owner   => root,
    group   => root,
    notify  => Service['syncthing']
  } ->

  file{'/etc/init.d/syncthing':
    ensure => link,
    target => '/etc/init/syncthing.conf',
    mode   => 'a+x',
  } -> Service['syncthing']

}
