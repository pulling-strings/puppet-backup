# setting up http://rclone.org/
class backup::rclone(
  $version = 'v1.20'
) {
  $url = "http://downloads.rclone.org/rclone-${version}-linux-amd64.zip"

  ensure_packages(['unzip'])

  archive {'rclone':
    ensure        => present,
    url           => $url,
    digest_string => 'a73a76bad165b35309e7dc71a17ee543',
    src_target    => '/usr/src',
    target        => '/opt/',
    extension     => 'zip',
    require       => Package['unzip']
  } ->

  file{'/usr/bin/rclone':
    ensure => link,
    target => "/opt/rclone/rclone-${version}-linux-amd64/rclone"
  }

}
