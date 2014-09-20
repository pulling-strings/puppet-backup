# Settings up copy.com, you must pass sysuser user and folder
class backup::copy(
  $url     = 'https://copy.com/install/linux/Copy.tgz',
  $sysuser = false,
  $user    = false,
  $folder  = false,
  $reinstall = false
  ){

  include backup::ulimit
  validate_string($sysuser, $user, $folder)

  ensure_packages(['curl'])

  if($reinstall) {
    file{'/usr/src/copy.tar.gz':
      ensure  => absent
    } ->

    file{'/opt/copy':
      ensure => absent,
      force  => true
    } -> Archive<||>
  }

  archive {'copy':
    ensure           => present,
    url              => $url,
    checksum         => false,
    src_target       => '/usr/src',
    target           => '/opt/',
    extension        => 'tar.gz',
    strip_components => 1,
    notify           => Service['copy']
  } ->

  file { '/etc/init/copy.conf':
    ensure  => file,
    mode    => '0777',
    content => template('backup/copy.erb'),
    owner   => root,
    group   => root,
  } ->

  file{'/etc/init.d/copy':
    ensure => link,
    target => '/etc/init/copy.conf'
  } ->

  service{'copy':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
