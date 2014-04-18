# Settings up copy.com, you must pass sysuser user and folder
class backup::copy(
  $url     = 'https://copy.com/install/linux/Copy.tgz',
  $sysuser = false,
  $user    = false,
  $folder  = false
  ){

  include backup::ulimit
  validate_string($sysuser, $user, $folder)

  archive {'Copy':
    ensure     => present,
    url        => $url,
    checksum   => false,
    src_target => '/var/tmp',
    target     => '/opt',
    extension  => 'tar.gz',
  }

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
  }
}
