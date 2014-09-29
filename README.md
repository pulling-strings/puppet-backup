# Intro

This module support multiple backup/storage setup including:

* Dropbox, headless installation.
* Copy.com, service and installation.
* Syncthing, setup peers configuration and repository management.
* Duply, backup jobs setup and scheduling.

# Usage

## Dropbox
```puppet
  class{'backup::dropbox':
    headless => true
  }
```
## Copy
```puppet
  class{'backup::copy':
    reinstall => true
  }
```
## Duply
```puppet
  $globs='- /home/vagrant/.*
  - /home/vagrant/vim*'


  # backup jobs
  backup::duply {'sample':
    source      => '/home/vagrant/',
    target      => 'file://tmp/backup',
    target_pass => 'foo',
    target_user => 'bla',
    passphrase  => 'blabla',
    globs       => $globs
  }

  backup::duply::schedule {'sample':
    onsuccess => '/usr/sbin/ssmtp foo@gmail.com </etc/duply/sample-msg.txt'
  }

  backup::duply {'s3-ex':
    source      => '/home/vagrant/',
    target      => 's3+http://myUniqueBucketName',
    target_pass => 'foo',
    target_user => 'bla',
    passphrase  => 'blabla',
    globs       => $globs
  }

  backup::duply::schedule {'s3-ex':
    precondition => '-d /tmp',
    shapping     => {
      interface  => 'eth0',
      port       => '2222',
      limit      => '45kbps'
    }
  }


```

## Syncthing
```puppet
  $repos = {
    appliances  => {
      directory => '~/appliances-1',
      ro        => false,
      nodes     => [
        'C56YYFN-U7QEMMU-2J3DVM4-RFHHNAT-FH7ATN6-VJSREZY-XKYXPOF-RSKC7QE',
      ]


    }
  }

  $nodes = {
    'C56YYFN-U7QEMMU-2J3DVM4-RFHHNAT-FH7ATN6-VJSREZY-XKYXPOF-RSKC7QE' => {name => 'foo' , address => 'foo:1234'},
  }


  class{'backup::syncthing':
    repos => $repos,
    nodes => $nodes,
    token => 'mhfu4ugmsauj6cgvsu68kvloa1gt3v'
  }
```

# Copyright and license

Copyright [2013] [Ronen Narkis]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.

You may obtain a copy of the License at:

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

