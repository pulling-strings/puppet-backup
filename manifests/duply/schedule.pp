# Schedule a daily backup job.
# Params:
# $precondition a check that will be made before the duply job runs
#  (by default an empty true value).
define backup::duply::schedule(
  $precondition='true',
  $onsuccess='',
  $shapping={}
) {

  if(has_key($shapping, 'interface') and has_key($shapping, 'limit') and has_key($shapping, 'port')){
    $run_shapping = true
    include backup::tc
  } else {
    $run_shapping = false
  }

  file { "/etc/cron.daily/duply-${name}":
    ensure  => file,
    mode    => '0777',
    content => template('backup/duply_cron.erb'),
    owner   => root,
    group   => root,
  }

  backup::duply::rotation {$name: }
}
