# Setting up https://github.com/restic/restic
class backup::restic {
  $version = '0.8.3'

  ensure_resource('package', 'bzip2', {'ensure' => 'present' })

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  $url = "https://github.com/restic/restic/releases/download/v${version}/restic_${version}_linux_amd64.bz2"

  file{'/usr/share/restic':
    ensure => directory,
  }

  -> downloadfile::and_md5check { "restic_${version}_linux_amd64":
      url    => $url,
      dest   => "/usr/share/restic/restic_${version}_linux_amd64",
      md5sum => '10b5fd75191637a1411027b9470e375c',
      chmod  => 'a+rx',
      user   => root,
      group  => root,
  }

  -> exec{'extract restic':
    command => "/bin/bzip2 -d restic_${version}_linux_amd64",
    user    => 'root',
    path    => ['/usr/bin','/bin',],
    cwd     => '/usr/share/restic/'
  }

  -> file{'/usr/bin/restic':
    ensure => link,
    target => "/usr/share/restic/restic_${version}_linux_amd64.out"
  }

}
