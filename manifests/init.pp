class nginx_lb {
	package { "nginx":
	 	ensure => installed,
	 }
	 service { "nginx":
	 	enable => true,
	 	ensure => running,
	 	hasrestart => true,
	 	hasstatus => true,
	 	require => Package["nginx"],
	 	restart => "/usr/bin/service nginx reload",
	 }
	 file {
	 	"/etc/nginx/certs/":
	 		ensure => directory,
	 }
}