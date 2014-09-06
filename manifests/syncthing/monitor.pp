# Sensu monitoring plugin for syncthing
class backup::syncthing::monitor(
  $token='', 
  $url='https://localhost:8080', 
  $plug_path = '/opt/sensu-narkisr-plugins/plugins/syncthing/'
) {
  
  sensu::check {'syncthing-status':
    command => "${plug_path}/check-status.rb -u ${url} -t ${token}"
  }

  sensu::check {'syncthing-errors':
    command => "${plug_path}/check-errors.rb -u ${url} -t ${token}"
  }
}
