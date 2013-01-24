
# Define: nginx_lb::site
# Parameters:
# $domain
# $ssl - defaults to false
#
define nginx_lb::site ($domain, $ssl=false, $ip=$ipaddress) {
	concat { "/etc/nginx/sites-enabled/${name}.conf":
		notify => Service['nginx'],
		require => Package['nginx'],
	}

	concat::fragment {"${name}_start":
		target => "/etc/nginx/sites-enabled/${name}.conf",
		order => 01,
		content => template("nginx_lb/nginx_start.erb")
	}
	concat::fragment {"${name}_end":
		target => "/etc/nginx/sites-enabled/${name}.conf",
		order => 99,
		content => template("nginx_lb/nginx_end.erb")
	}

	if ($ssl != false) {
		file {
			"/etc/nginx/certs/${name}.crt":
				require => File['/etc/nginx/certs/'],
				source	=> "puppet:///files/certs/${name}.crt",
		}
		file {
			"/etc/nginx/certs/${name}.key":
				require => File['/etc/nginx/certs/'],
				source	=> "puppet:///files/certs/${name}.key",
		}
	}
}

# Define: nginx_lb::site
# Parameters:
# $site - the site given in nginx_lb::site
# $endpoint - e.g. http://10.0.0.2:8001/
# $weight - Between 1 and 100. Defaults to 10
#
define nginx_lb::endpoint ($site, $endpoint, $weight=10) {
	concat::fragment {"${site}_${endpoint}":
		target => "/etc/nginx/sites-enabled/${site}.conf",
		order => $weight,
		content => "\n server $endpoint weight=${weight};",
	}
	
}