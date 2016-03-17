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
define kerberos::kdc::realm::master
(
  $password,
  $realm  = $name,
  $master = $::fqdn,

  $ensure = 'present',

  $manage_realm     = true,
  $domain           = undef,
  $iprop_port       = $::kerberos::params::kdc_kpropd_iprop_port,
  $realm_parameters = {},

  $manage_host_principal = true,
  $host_principal        = undef,

  $manage_kiprop_principal = true,
  $kiprop_principal        = undef,

  $manage_kadmin_server_acl_kiprop_principal      = true,
  $kadmin_server_acl_kiprop_principal_permissions = 'p',

  $kdc_kadmin_server_acl_file = $::site::params::kdc_kadmin_server_acl_file,
)
{
  $_host_principal   = pick($host_principal, "host/${master}@${realm}")
  $_kiprop_principal = pick($kiprop_principal, "kiprop/${master}@${realm}")

  if ($manage_realm)
  {
    create_resources('::kerberos::kdc::realm', { $realm => merge(
    {
      'ensure'       => $ensure,
      'domain'       => $domain,
      'password'     => $password,
      'iprop_enable' => true,
      'iprop_port'   => $iprop_port,
    }, $realm_parameters) })
  }

  if ($manage_host_principal)
  {
    ::kerberos::kdc::principal
    { $_host_principal:
      ensure => $ensure,
    }
  }

  if ($manage_kiprop_principal)
  {
    ::kerberos::kdc::principal
    { $_kiprop_principal:
      ensure => $ensure,
    }
  }

  if ($manage_kadmin_server_acl_kiprop_principal)
  {
    ::kerberos::kdc::kadmin_server::acl::principal
    { $_kiprop_principal:
      ensure      => $ensure,
      permissions => $kdc_kadmin_server_acl_kiprop_principal_permissions,
      file        => $kdc_kadmin_server_acl_file,
    }
  }
}
