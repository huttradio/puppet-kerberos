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
define kerberos::client::conf::appdefaults::realm
(
  $subsection,
  $realm = $name,

  $ensure = 'present',

  $client_conf_file = $::kerberos::client::conf::file,
)
{
  validate_hash($subsection)

  if ($ensure == 'present')
  {
    concat::fragment
    { "${client_conf_file}::appdefaults::${realm}":
      target  => $client_conf_file,
      order   => "06-${realm}",
      content => template('kerberos/client/conf/appdefaults/realm.erb'),
    }
  }
}
