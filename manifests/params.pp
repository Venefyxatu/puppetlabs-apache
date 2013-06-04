# Class: apache::params
#
# This class manages Apache parameters
#
# Parameters:
# - The $user that Apache runs as
# - The $group that Apache runs as
# - The $apache_name is the name of the package and service on the relevant
#   distribution
# - The $php_package is the name of the package that provided PHP
# - The $ssl_package is the name of the Apache SSL package
# - The $apache_dev is the name of the Apache development libraries package
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class apache::params {
  # This will be 5 or 6 on RedHat, 6 or wheezy on Debian, 12 or quantal on Ubuntu, etc.
  $osr_array = split($::operatingsystemrelease,'[\/\.]')
  $distrelease = $osr_array[0]
  if ! $distrelease {
    fail("Class['apache::params']: Unparsable \$::operatingsystemrelease: ${::operatingsystemrelease}")
  }

  if $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {
    $user                 = 'apache'
    $group                = 'apache'
    $apache_name          = 'httpd'
    $service_name  = 'httpd'
    $httpd_dir            = '/etc/httpd'
    $conf_dir             = "${httpd_dir}/conf"
    $confd_dir            = "${httpd_dir}/conf.d"
    $mod_dir              = "${httpd_dir}/conf.d"
    $vhost_dir            = "${httpd_dir}/conf.d"
    $conf_file            = 'httpd.conf'
    $ports_file           = "${conf_dir}/ports.conf"
    $logroot              = '/var/log/httpd'
    $lib_path             = 'modules'
    $mpm_module           = 'prefork'
    $dev_packages         = 'httpd-devel'
    $default_ssl_cert     = '/etc/pki/tls/certs/localhost.crt'
    $default_ssl_key      = '/etc/pki/tls/private/localhost.key'
    $ssl_certs_dir        = $distrelease ? {
      '5' => '/etc/pki/tls/certs',
      '6' => '/etc/ssl/certs',
    }
    $passenger_root       = '/usr/share/rubygems/gems/passenger-3.0.17'
    $passenger_ruby       = '/usr/bin/ruby'
    $mod_packages         = {
      'auth_kerb'  => 'mod_auth_kerb',
      'fcgid'      => 'mod_fcgid',
      'passenger'  => 'mod_passenger',
      'perl'       => 'mod_perl',
      'proxy_html' => 'mod_proxy_html',
      'python'     => 'mod_python',
      'shibboleth' => 'shibboleth',
      'ssl'        => 'mod_ssl',
      'wsgi'       => 'mod_wsgi',
    }
    $mod_packages['php5'] = $distrelease ? {
      '5' => 'php53',
      '6' => 'php',
    }
    $mod_libs             = {
      'php5' => 'libphp5.so',
    }
  } elsif $::osfamily == 'Debian' {
    $user             = 'www-data'
    $group            = 'www-data'
    $apache_name      = 'apache2'
    $service_name  = 'httpd'
    $httpd_dir        = '/etc/apache2'
    $conf_dir         = "${httpd_dir}"
    $confd_dir        = "${httpd_dir}/conf.d"
    $mod_dir          = "${httpd_dir}/mods-available"
    $mod_enable_dir   = "${httpd_dir}/mods-enabled"
    $vhost_dir        = "${httpd_dir}/sites-enabled"
    $conf_file        = 'apache2.conf'
    $ports_file       = "${conf_dir}/ports.conf"
    $logroot          = '/var/log/apache2'
    $lib_path         = '/usr/lib/apache2/modules'
    $mpm_module       = 'worker'
    $dev_packages     = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
    $default_ssl_cert = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
    $default_ssl_key  = '/etc/ssl/private/ssl-cert-snakeoil.key'
    $ssl_certs_dir    = '/etc/ssl/certs'
    $passenger_root   = '/usr'
    $passenger_ruby   = '/usr/bin/ruby'
    $mod_packages    = {
      'wsgi'       => 'libapache2-mod-wsgi',
    }
    $mod_libs              = {}
    $mod_identifiers       = {}
  } elsif $::operatingsystem == 'Gentoo' {
    $user                  = 'apache'
    $group                 = 'apache'
    $apache_name           = 'apache'
    $service_name          = 'apache2'
    $mod_passenger_package = 'libapache2-mod-passenger'
    $mod_python_package    = 'libapache2-mod-python'
    $mod_wsgi_package      = 'libapache2-mod-wsgi'
    $mod_auth_kerb_package = 'libapache2-mod-auth-kerb'
    $confd_dir             = '/etc/apache2/conf.d'
    $conf_dir              = '/etc/apache2'
    $conf_file             = 'httpd.conf'
    $httpd_dir             = '/usr/lib64/apache2'
    $logroot               = '/var/log/apache2'
    $lib_path              = 'modules'
    $mod_dir               = '/etc/apache2/modules.d'
    $vhost_dir             = '/etc/apache2/vhosts.d'
    $ports_file            = '/etc/apache2/ports.conf'
    $apache_dev            = ['libaprutil1-dev', 'libapr1-dev', 'apache2-prefork-dev']
    $vdir                  = '/etc/apache2/vhosts.d'
    $mod_packages     = {
      'auth_kerb'  => 'libapache2-mod-auth-kerb',
      'fcgid'      => 'libapache2-mod-fcgid',
      'passenger'  => 'libapache2-mod-passenger',
      'perl'       => 'libapache2-mod-perl2',
      'proxy_html' => 'libapache2-mod-proxy-html',
      'python'     => 'libapache2-mod-python',
      'wsgi'       => 'libapache2-mod-wsgi',
    }
    $mod_libs         = {}
  } else {
    fail("Class['apache::params']: Unsupported osfamily: ${::osfamily}")
  }
}
