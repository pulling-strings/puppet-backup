# Setting up zbackup from source
class backup::zbackup {

  include barbecue

  package{'zbackup':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }



}
