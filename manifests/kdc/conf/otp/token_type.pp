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
define kerberos::kdc::conf::otp::token_type
(
  $ensure         = 'present',
  $manage_section = true,

  $server      = undef,
  $secret      = undef,
  $timeout     = undef,
  $retries     = undef,
  $strip_realm = undef,

  $kdc_conf_file = $::kerberos::kdc::conf::file,
)
{
  if ($ensure == 'present')
  {
    if ($manage_section)
    {
      include ::kerberos::kdc::conf::otp
    }

    concat::fragment
    { "${kdc_conf_file}::otp::${name}":
      target  => $kdc_conf_file,
      order   => "06-${name}",
      content => template('kerberos/kdc/conf/otp_token.erb'),
    }
  }
}
