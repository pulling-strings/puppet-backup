# Sets up a duply backup job
define backup::duply(
  $source='',
  $passphrase=false,
  $target='',
  $user='',
  $password='',
  $max_age='1M',
  $max_full_backups='1',
  $max_fullbkp_age='1M',
  $volsize=50,
  $globs='',
  $tmp='/tmp',
  $target_user=false,
  $target_pass=false,
  $dupliticy_options=''
) {

  validate_string($target_pass, $target_user, $passphrase)

  if($::osfamily == 'Redhat') {
    include epel
    Yumrepo <||> -> Package <||>
  }

  ensure_resource('package', 'duply', {'ensure' => 'present' })
  ensure_resource('package', 'duplicity', {'ensure' => 'present' })
  ensure_resource('package', 'python-boto', {'ensure' => 'present' })
  ensure_resource('package', 'python-paramiko', {'ensure' => 'present' })
  ensure_resource('file', '/etc/duply', {'ensure' => 'directory' })

  file{"/etc/duply/${name}":
    ensure => directory,
  }

  file { "/etc/duply/${name}/exclude" :
    ensure  => file,
    content => $globs,
    owner   => root,
    require =>  [Package['duply'],File["/etc/duply/${name}"]],
  }

  if($target=~/s3.*/ and ($target_user == undef or $target_pass == undef)){
    fail('both target_user and target_pass muse be provided when using s3')
  }

  file{"/etc/duply/${name}/conf":
    ensure  => file,
    content => template('backup/conf.erb'),
    owner   => root,
    require =>  [Package['duply'],File["/etc/duply/${name}"]],
  }

}
