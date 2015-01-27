# Dropbox installation and managment
# In order to link account in headless mode:
# DAEMON=/usr/local/dropbox/dropbox-deamon/.dropbox-dist/dropboxd
# sudo start-stop-daemon -o -c $dbuser -S -u $dbuser -x $DAEMON
# $dbuser is the user running dropbox 
class backup::dropbox(
  $headless=false,
  $user=''
) {

  include backup::ulimit

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

    file { '/etc/init.d/dropbox':
      ensure => file,
      mode   => '0700',
      source => 'puppet:///modules/backup/dropbox.init',
      owner  => root,
      group  => root,
    }
  } else {
    $os_lowercase = downcase($::operatingsystem)

    apt::source { 'dropbox':
      location    => "http://linux.dropbox.com/${os_lowercase}",
      release     => $::lsbdistcodename,
      repos       => 'main',
      include_src => false,
    } ->

    apt::key { 'dropbox':
      key        => '5044912E',
      key_server => 'pgp.mit.edu',
    } ->

    package{'dropbox':
      ensure  => present
    }

    # file { '/etc/init/dropbox.conf':
    #   ensure=> file,
    #   mode  => '0644',
    #   content => template('template'),
    #   owner => root,
    #   group => root,
    # }
  }
}
