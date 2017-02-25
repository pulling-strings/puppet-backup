# Setting up an s3 endpoint
define backup::rclone::s3(
  $key_id,
  $access_key_id,
  $storage_class = 'STANDARD'
){
  file{'/etc/rclone':
    ensure => directory,
  } ->

  file { "/etc/rclone/${name}":
    ensure  => file,
    mode    => '0644',
    content => template('backup/rclone_s3.erb'),
    owner   => root,
    group   => root,
  }


}
