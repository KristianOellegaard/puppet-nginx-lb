class nginx_lb {
	package { "nginx":
	 	ensure => installed,
	 }
	 service { "nginx":
	 	enable => true,
	 	ensure => running,
	 	hasrestart => true,
	 	hasreload => true,
	 	hasstatus => true,
	 	require => Package["nginx"],
	 }
	 file {
	 	"/etc/nginx/certs/":
	 		ensure => directory,
	 }
}