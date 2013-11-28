# Schedule a daily backup job. 
define backup::schedule {

  file { "/etc/cron.daily/duply-$name":
    ensure=> file,
    mode  => '0777',
    content => template('backup/cron.erb'),
    owner => root,
    group => root,
  }
}
