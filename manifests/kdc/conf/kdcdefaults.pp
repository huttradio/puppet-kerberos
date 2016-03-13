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
class kerberos::kdc::conf::kdcdefaults
(
  $ensure = 'present',

  $host_based_services       = undef,
  $kdc_ports                 = undef,
  $kdc_tcp_ports             = undef,
  $no_host_referral          = undef,
  $restrict_anonymous_to_tgt = undef,
  $kdc_max_dgram_reply_size  = undef,

  $kdc_conf_file = $::kerberos::kdc::conf::file,
) inherits kerberos::params
{
  if ($ensure == 'present')
  {
    concat::fragment
    { "${kdc_conf_file}::kdcdefaults":
      target  => $kdc_conf_file,
      order   => '02',
      content => template('kerberos/kdc/conf/kdcdefaults.erb'),
    }
  }
}
