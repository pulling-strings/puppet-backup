# log rotation for duply log files
define backup::duply::rotation {
  logrotate::rule { $name:
    path         => "/var/log/duply_${name}.log",
    rotate       => 2,
    size         => '10M',
    rotate_every => 'day',
  }
}
