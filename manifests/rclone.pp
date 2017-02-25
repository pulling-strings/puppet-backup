# setting up http://rclone.org/
class backup::rclone(
  $version = 'v1.35'
) {

  $arch = $::architecture ? {
    'amd64'  => 'amd64',
    'armv6l' => 'arm'
  }

  $sum = $::architecture ? {
    'amd64'  => '398d20b3c849e5c20d0a9c1db8d25bfd',
    'armv6l' => '3f358b653dc04b8304d0a5cb5a6e444b'
  }

  $url = "http://downloads.rclone.org/rclone-${version}-linux-${arch}.zip"

  ensure_packages(['unzip'])

  archive {'rclone':
    ensure        => present,
    url           => $url,
    digest_string => $sum,
    src_target    => '/usr/src',
    target        => '/opt/',
    extension     => 'zip',
    require       => Package['unzip']
  } ->

  file{'/usr/bin/rclone':
    ensure => link,
    target => "/opt/rclone/rclone-${version}-linux-${arch}/rclone"
  }

}
