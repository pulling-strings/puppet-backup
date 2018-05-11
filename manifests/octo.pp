# Octo github backup
class backup::octo {

  include barbecue

  package{'openjdk-8-jre':
    ensure  => present
  }

  -> package{'octo':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }

}
