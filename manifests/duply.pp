# Sets up a duply backup job
define backup::duply(
  $source='',
  $passphrase='',
  $target='',
  $user='',
  $password='',
  $max_age='1M',
  $max_full_backups='1',
  $max_fullbkp_age='1M',
  $volsize=50,
  $globs='', 
  $tmp='/tmp'
  ) {

  if !defined(Package['duply']) {
    package{'duply':
      ensure  => present
    }
  }

  if !defined(Package['duplicity']) {
    package{['duplicity']:
      ensure  => present
    }
  }

  if !defined(Package['python-boto']) {
   package{'python-boto':
     ensure  => present
   }
  }

  if !defined(File['/etc/duply']) {
   file{['/etc/duply']:
    ensure => directory,
   }
  }

  file{"/etc/duply/${name}":
    ensure => directory,
  }

  file { "/etc/duply/${name}/exclude" :
    ensure  => file,
    content => $globs,
    owner   => root,
    require =>  [Package['duply'],File["/etc/duply/${name}"]],
  }

  file{"/etc/duply/${name}/conf":
    ensure  => file,
    content => template('backup/conf.erb'),
    owner   => root,
    require =>  [Package['duply'],File["/etc/duply/${name}"]],
  }

}
