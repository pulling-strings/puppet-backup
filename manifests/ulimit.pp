# Increasing max file handle limits
class backup::ulimit {
  # Dropbox
  file_line { 'max-watches':
    path => '/etc/sysctl.conf',
    line => 'fs.inotify.max_user_watches = 200000'
  }

  # Dropbox
  file_line { 'file-max':
    path => '/etc/sysctl.conf',
    line => 'fs.file-max = 800000'
  }
}
