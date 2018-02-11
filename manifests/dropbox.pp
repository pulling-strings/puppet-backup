# Dropbox installation and managment (make sure to link in headless mode)
class backup::dropbox(
  Boolean $headless=false,
  String $home='',
  String $user='',
) {

  include downloadfile
  include backup::ulimit

  if($headless) {
    $headless_url='https://www.dropbox.com/download?plat=lnx.x86_64'

    archive { 'dropbox-deamon':
      ensure   => present,
      url      => $headless_url,
      checksum => false,
      target   => '/usr/local/',
      timeout  => 6000
    }

    -> file{"${home}/.dropbox-dist":
      ensure => link,
      target => '/usr/local/dropbox-deamon/.dropbox-dist/'
    }

    file{"${home}/bin/":
      ensure => directory,
    }

    -> downloadfile::and_md5check { 'dropbox':
      url    => 'https://www.dropbox.com/download?dl=packages/dropbox.py',
      dest   => "${home}/bin/dropbox",
      md5sum => 'd7e01a4d178674f1895dc3f74adb7f36',
      user   => $user,
      group  => $user,
      chmod  => '770',
    }


  } else {
    $os_lowercase = downcase($::operatingsystem)

    apt::source { 'dropbox':
      location => "http://linux.dropbox.com/${os_lowercase}",
      release  => $::lsbdistcodename,
      repos    => 'main',
      include  => {
        src => false,
      }
    }

    -> apt::key { 'dropbox':
      id     => '1C61A2656FB57B7E4DE0F4C1FC918B335044912E',
      server => 'pgp.mit.edu',
    }

    -> package{'dropbox':
      ensure  => present
    }

  }
}
