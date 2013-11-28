# Settings up copy.com
class backup::copy(
  $url     = 'https://copy.com/install/linux/Copy.tgz',
  $sysuser = '',
  $user    = ''
  ){

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
  }
}
