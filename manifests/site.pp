
# Define: nginx_lb::site
# Parameters:
# $site
# $domain
# $ssl - defaults to false
#
define nginx_lb::site ($site, $domain, $ssl=false) {
	concat { "/etc/nginx/sites-enabled/${site}.conf":
		notify => Service['nginx'],
	}

	concat::fragment {"${site}_start":
		target => "/etc/nginx/sites-enabled/${site}.conf",
		order => 0,
		content => template("nginx_start.erb")
	}
	concat::fragment {"${site}_end":
		target => "/etc/nginx/sites-enabled/${site}.conf",
		order => 101,
		content => template("nginx_end.erb")
	}

	if ($ssl != false) {
		file {
			"/etc/nginx/certs/$site.crt":
				require => File['/etc/nginx/certs/'],

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
		content => "server $endpoint weight=${weight};"
	}
	
}