# Dropbox installation and managment
# In order to link account in headless mode:
# sudo su -l dropbox -s /bin/bash
# umask 0027
# /usr/local/dropbox/.dropbox-dist/dropboxd
class backup::dropbox($headless=false) {

  if($headless) {
    archive { 'dropbox-deamon':
      ensure   => present,
      url      => 'https://www.dropbox.com/download?plat=lnx.x86_64',
      checksum => false,
      target   => '/usr/local/dropbox',
    }

    group{'dropbox':
      ensure  => present
    } ->

    user{'dropbox':
      ensure     => present,
      comment    => 'dropbox',
      groups     => 'dropbox',
      managehome => true,
      home       => '/home/dropbox',
      shell      => '/bin/false',
      system     => true
    } ->

    file{'/home/dropbox/Dropbox':
      ensure => directory,
      owner  => 'dropbox',
      group  => 'dropbox'
    } ->

    file { '/etc/init/dropbox.conf':
      ensure=> file,
      mode  => '0700',
      source=> 'puppet:///modules/backup/dropbox.conf',
      owner => root,
      group => root,
    }

    file{'/etc/init.d/dropbox':
      ensure => link,
      target => '/etc/init/dropbox.conf'
    }
  } else {
    $os_lowercase = downcase($::operatingsystem)

    apt::source { 'dropbox':
      location          => "http://linux.dropbox.com/${os_lowercase}",
      release           => $::lsbdistcodename,
      repos             => 'main',
      include_src       => false,
    } ->

    apt::key { 'dropbox':
      key        => '5044912E',
      key_server => 'pgp.mit.edu',
    } ->

    package{'dropbox':
      ensure  => present
    }
  }
}
