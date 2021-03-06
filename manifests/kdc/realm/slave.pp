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
define kerberos::kdc::realm::slave
(
  $master,
  $password,
  $slave = $::fqdn,
  $realm = $name,

  $ensure = 'present',

  $manage_realm     = true,
  $domain           = undef,
  $iprop_port       = $::kerberos::params::kdc_kpropd_iprop_port,
  $realm_parameters = {},

  $manage_kpropd_acl_realm       = true,

  $manage_kpropd_bootstrap_realm = true,
  $master_ssh_key                = undef,

  $manage_dependencies = true,
)
{
  if ($manage_realm)
  {
    create_resources('::kerberos::kdc::realm', { $realm => merge(
    {
      'ensure'       => $ensure,
      'domain'       => $domain,
      'kdc'          => ['localhost', $master],
      'admin_server' => $master,
      'password'     => $password,
      'iprop_enable' => true,
      'iprop_port'   => $iprop_port,
    }, $realm_parameters) })
  }

  if ($manage_kpropd_acl_realm)
  {
    ::kerberos::kdc::kpropd::acl::realm
    { $realm:
      ensure => $ensure,
      master => $master,
    }
  }

  if ($manage_kpropd_bootstrap_realm)
  {
    ::kerberos::kdc::kpropd::bootstrap::realm
    { $realm:
      ensure              => $ensure,
      master              => $master,
      master_ssh_key      => $master_ssh_key,
      slave               => $slave,
      manage_dependencies => $manage_dependencies,
    }
  }
}
