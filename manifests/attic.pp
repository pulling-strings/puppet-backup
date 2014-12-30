# Setting up https://attic-backup.org/index.html
class backup::attic($owner='root',$fuse=false) {
  ensure_resource('class', 'apt', {})

  ensure_resource('package', 'build-essential', {ensure => present})

  apt::ppa {'ppa:fkrull/deadsnakes':
  } ->

  package{['python3.2', 'python3.2-dev', 'python3-pip', 'libacl1-dev']:
    ensure  => present
  } ->

  exec{'installing attic':
    command => 'pip3 install attic',
    user    => 'root',
    path    => ['/usr/bin','/bin'],
    unless  => '/usr/bin/pip3 list | grep Attic'
  }

  if($fuse == true){
    package{['python3-dev', 'libattr1-dev', 'libfuse-dev',
              'fuse', 'pkg-config']:
      ensure  => present
    } ->

    exec{'installing llfuse':
      command => 'pip3 install llfuse',
      user    => 'root',
      path    => ['/usr/bin','/bin'],
      unless  => '/usr/bin/pip3 list | grep llfuse',
      require => Package['python3.2', 'python3.2-dev', 'python3-pip', 'libacl1-dev']
    }
  }

}
