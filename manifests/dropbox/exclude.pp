# Dropbox exclusion
class backup::dropbox::exclude(
  $excluded=[],
  $included=[]
){
  if($dropbox::headless){
    exec{'get dropbox.py':
      command => 'wget http://www.dropbox.com/download?dl=packages/dropbox.py',
      user    => 'root',
      path    => ['/usr/bin','/bin',]
    }
  } else {


    if($excluded != []){
      $exclude_list = join($excluded,' ')
      exec{"excluding ${exclude_list} from dropbox sync":
        command   => "dropbox exclude add ${exclude_list}",
        user      => $backup::dropbox::user,
        path      => ['/usr/bin','/bin'],
        require   => Package['dropbox'],
        logoutput => true,
        unless    => 'dropbox status | grep isn'
      }
    }

    if($included!= []){
      $include_list = join($included,' ')
      exec{"including ${include_list} in dropbox sync":
        command => "dropbox exclude remove ${include_list}",
        user    => $backup::dropbox::user,
        path    => ['/usr/bin','/bin'],
        require => Package['dropbox'],
        unless  => 'dropbox status | grep isn'
      }
    }
  }
}

