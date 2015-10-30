# setting up http://rclone.org/
class backup::rclone(
  $version = 'v1.23'
) {

  $arch = $::architecture ? {
    'amd64'  => 'amd64',
    'armv6l' => 'arm'
  }

  $sum = $::architecture ? {
    'amd64'  => 'e33fe68ced1263c8e056effd99c49ad4',
    'armv6l' => '9898b16436f74effd64a46af26e25362'
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
