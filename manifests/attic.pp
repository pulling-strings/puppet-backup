# Setting up https://attic-backup.org/index.html
class backup::attic($owner='root') {
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
    path    => ['/usr/bin','/bin']
  }

}
