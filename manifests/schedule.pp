# Schedule a backup job for daily/monthly periods.
define backup::schedule(
  $hour='',
  $monthday=undef,
  $type='duply',
  $trickle=undef
) {

  $log = "/var/log/duply_${name}.log"
  $tee = "sudo tee ${log} 2>&1"
  $lock = "flock -n /tmp/${$name}"
  $base_run = "duply ${name} backup_verify_purge --force | ${tee}"

  if($trickle!=undef){
    $run = "${lock} trickle -u ${trickle} -s ${base_run}"
    if !defined(Package['trickle']) {
      package{'trickle':
        ensure  => present
      }
    }
  } else {
    $run = "${lock} ${base_run}"
  }

  cron { "${name}_duply_backup_cron":
    ensure   => present,
    command  =>  $type ? {
      'duply' => $run
    },
    user     => 'root',
    hour     => $hour,
    monthday => $monthday,
    require  => File["/etc/duply/${name}/conf"],
  }

}
