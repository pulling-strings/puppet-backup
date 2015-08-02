# Setting up zbackup from source
class backup::zbackup {

  include downloadfile

  archive {'zbackup':
    ensure           => present,
    url              => 'https://github.com/zbackup/zbackup/archive/1.4.2.tar.gz',
    digest_string    => 'eceb8c81ce593205cb51c6bb74031764' ,
    src_target       => '/usr/src',
    target           => '/opt/',
    strip_components => 1
  }

  package{['cmake', 'protobuf-compiler', 'libprotobuf-dev', 'liblzo2-dev',
            'liblzma-dev']:
    ensure  => present
  } ->

  exec{'cmake zbackup':
    command => 'cmake .',
    user    => 'root',
    path    => ['/usr/bin','/bin',],
    cwd     => '/opt/zbackup',
    unless  => 'test -f /usr/bin/local/zbackup'
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
