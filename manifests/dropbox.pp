# Dropbox installation and managment
# In order to link account in headless mode:
# DAEMON=/usr/local/dropbox/dropbox-deamon/.dropbox-dist/dropboxd
# sudo start-stop-daemon -o -c $dbuser -S -u $dbuser -x $DAEMON
# $dbuser is the user running dropbox 
class backup::dropbox(
  $headless=false,
  $user='',
  $headless_url='https://www.dropbox.com/download?plat=lnx.x86_64',
  $headless_version = '3.10.9'
) {

  include backup::ulimit

  if($headless) {
    archive { 'dropbox-deamon':
      ensure   => present,
      url      => $headless_url,
      checksum => false,
      target   => '/usr/local/',
    } ->

    file{'/usr/local/bin/dropbox':
      ensure => link,
      target => "/usr/local/dropbox-deamon/.dropbox-dist/dropbox-lnx.x86_64-${headless_version}/dropbox"
    } ->

    file { '/etc/systemd/system/dropbox.service':
      ensure => file,
      mode   => '0700',
      source => 'puppet:///modules/backup/dropbox.service',
      owner  => root,
      group  => root,
    } ->

    exec{'enable dropbox service':
      command => 'systemctl enable dropbox',
      user    => 'root',
      path    => ['/usr/bin','/bin',],
      unless  => 'systemctl is-enabled dropbox'
    }

    # service{'dropbox':
    #   ensure    => running,
    #   provider  => 'systemd',
    #   enable    => true,
    #   hasstatus => true,
    # }
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

  }
}
