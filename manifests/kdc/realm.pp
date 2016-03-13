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
define kerberos::kdc::realm
(
  $ensure = 'present',
  $realm  = $title,

  $slaves = undef,
  $master = undef,

  $manage_client_realm     = true,
  $domain                  = undef,
  $client_realm_parameters = {},

  $manage_kdc_conf_realm     = true,
  $kdc_conf_realm_parameters = {},

  $manage_realm_db = true,
)
{
  if ($manage_client_realm)
  {
    create_resources('::kerberos::client::realm', $realm, merge(
    {
      'ensure' => $ensure,
      'domain' => $domain,
    }, $client_realm_parameters)
  }

  if ($manage_kdc_conf_realm)
  {
    create_resources('::kerberos::kdc::conf::realm', $realm, merge(
    {
      'ensure' => $ensure,
    }, $kdc_conf_realm_parameters)
  }

  if ($manage_realm_db)
  {
    ::kerberos::kdc::realm::db
    { $realm:
      ensure => $ensure,
    }
  }
}
