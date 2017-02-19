# Octo github backup
class backup::octo {

  include barbecue
  include jdk

  package{'octo':
    ensure  => present,
    require => [Apt::Source['barbecue'], Class['apt::update']]
  }

  file {'/etc/cron.daily/octo':
    ensure  => file,
    mode    => '0777',
    content => template('backup/duply_cron.erb'),
    owner   => root,
    group   => root,
  }

}
