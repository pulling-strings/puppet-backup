# Installing tarsnap
class backup::tarsnap{

  include barbecue

  package{'tarsnap':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }



}
