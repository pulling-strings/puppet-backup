# Octo github backup
class backup::octo {

  include barbecue
  include jdk

  package{'octo':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }

}
