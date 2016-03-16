# Class: kerberos
# ===========================
#
# Full description of class kerberos here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'kerberos':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Callum Dickinson <callum@huttradio.co.nz>
#
# Copyright
# ---------
#
# Copyright 2016 Hutt Community Radio and Audio Archives Charitable Trust.
#
define kerberos::client::conf::realms::realm
(
  $realm = $name,

  $ensure         = 'present',
  $manage_section = true,

  $admin_server        = undef,
  $auth_to_local       = undef,
  $auth_to_local_names = undef,
  $default_domain      = undef,
  $http_anchors        = undef,
  $kdc_dns_srv         = false,
  $kdc                 = undef,
  $kpasswd_server      = undef,
  $master_kdc          = undef,
  $v4_instance_convert = undef,
  $v4_realm            = undef,

  $client_conf_file = $::kerberos::client::conf::file,
)
{
  # Validate parameters.
  if ($kdc_dns_srv == false)
  {
    validate_string($kdc)
  }

  if ($ensure == 'present')
  {
    # Include section class.
    if ($manage_section)
    {
      include ::kerberos::client::conf::realms
    }

    ::concat::fragment
    { "${client_conf_file}::realms::${realm}":
      ensure  => $ensure,
      target  => $client_conf_file,
      order   => "03-${realm}",
      content => template('kerberos/client/conf/realms/realm.erb'),
    }
  }
} 
