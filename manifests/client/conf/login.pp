# == Class: kerberos
#
# Full description of class kerberos here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { kerberos:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class kerberos::client::conf::login
(
  $ensure = 'present',

  $krb4_convert     = undef,
  $krb4_get_tickets = undef,
  $krb5_get_tickets = undef,
  $krb_run_aklog    = undef,
  $aklog_path       = undef,
  $accept_passwd    = undef,

  $client_conf_file = $::kerberos::client::conf::file,
)
{
  if ($ensure == 'present')
  {
    concat::fragment
    { "${client_conf_file}::login":
      target  => $client_conf_file,
      order   => '08',
      content => template('kerberos/client/conf/login.erb'),
    }
  }
}
