# setting up http://rclone.org/
class backup::rclone {
  include barbecue

  package{'rclone':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }


}
