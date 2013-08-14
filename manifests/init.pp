#init.pp

class heartbeat ( $authkey, ## [ 'type', 'PutYourSuperSecretKeyHere' ]
		  $keepalive,
		  $deadtime,
		  $warntime,
		  $initdead,
		  $hacfdirectives,
		  $nodes, ## Array of hashes representing nodes (name,realip,svcip,hanetif)
		  $services, ## Array specifying the services that need to be started by heartbeat 
		  $dnsdomain, 
		) {
        package { "heartbeat": ensure => present }

	file { '/etc/ha.d/authkeys':
                owner => 'root', group => 'root', mode => '0400',
                content => template('heartbeat/authkeys.erb'),
                require => Package["heartbeat"],
        }
        file { '/etc/ha.d/ha.cf':
                owner => 'root', group => 'root', mode => '0400',
                content => template('heartbeat/ha.cf.erb'),
                require => Package["heartbeat"],
        }
        file { '/etc/ha.d/haresources':
                owner => 'root', group => 'root', mode => '0400',
                content => template('heartbeat/haresources.erb'),
                require => Package["heartbeat"],
        }
	
        service{'heartbeat':
                subscribe => [
                        File['/etc/ha.d/authkeys'],
                        File['/etc/ha.d/ha.cf'],
                        File['/etc/ha.d/haresources'],
                ],
                enable => true,
                require => [
			Package["heartbeat"],
		],
		ensure => running,
        }

}

