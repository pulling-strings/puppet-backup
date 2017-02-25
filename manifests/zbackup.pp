# Setting up zbackup from source
class backup::zbackup {

  include downloadfile

  archive {'zbackup':
    ensure           => present,
    url              => 'https://github.com/zbackup/zbackup/archive/1.4.4.tar.gz',
    digest_string    => '0753ca5d61533f951d6ebb6f087efa0b' ,
    src_target       => '/usr/src',
    target           => '/opt/',
    strip_components => 1
  }

  ensure_packages(['build-essential'])

  package{['cmake', 'protobuf-compiler', 'libprotobuf-dev', 'liblzo2-dev',
            'liblzma-dev','libssl-dev']:
    ensure  => present
  } ->

  exec{'cmake zbackup':
    command => 'cmake .',
    user    => 'root',
    path    => ['/usr/bin','/bin',],
    cwd     => '/opt/zbackup',
    unless  => 'test -f /usr/bin/local/zbackup',
    require => Package['build-essential']
  } ->

  exec{'make zbackup':
    command => 'make',
    user    => 'root',
    path    => ['/usr/bin','/bin',],
    cwd     => '/opt/zbackup',
    unless  => 'test -f /usr/bin/local/zbackup',
  } ->

  file{'/usr/local/bin/zbackup':
    ensure => link,
    target => '/opt/zbackup/zbackup'
  }


}
