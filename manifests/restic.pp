# Setting up https://github.com/restic/restic
class backup::restic {
  $version = '0.8.3'

  ensure_resource('package', 'bzip2', {'ensure' => 'present' })

  Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  $url = "https://github.com/restic/restic/releases/download/v${version}/restic_${version}_linux_amd64.bz2"

  archive { "restic_${version}_linux_amd64":
    ensure        => present,
    url           => $url,
    digest_string => '1e9aca80c4f4e263c72a83d4333a9dac0e24b24e1fe11a8dc1d9b38d77883705',
    digest_type   => 'sha256',
    src_target    => '/opt',
    target        => '/usr/share/restic/',
    extension     => 'bzip',
    require       => Package['bzip2'],
  }

  -> file{'/usr/bin/restic':
    ensure => link,
    target => "/usr/share/restic/restic_${version}_linux_amd64"
  }

}
