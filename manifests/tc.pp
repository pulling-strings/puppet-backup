# tc based trafic limiting for backup jobs
class backup::tc {

  file { '/usr/local/bin/limit-upload':
    ensure=> file,
    mode  => 'a+x',
    source=> 'puppet:///modules/backup/tc.sh',
    owner => root,
    group => root,
  }
}
