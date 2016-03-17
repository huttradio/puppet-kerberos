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
define kerberos::kdc::kpropd::bootstrap::realm
(
  $master,
  $slave = $::fqdn,
  $realm = $name,

  $ensure              = 'present',
  $manage_dependencies = true,

  $slave_host_principal  = undef,
  $master_host_principal = undef,

  $slave_kiprop_principal  = undef,
  $master_kiprop_principal = undef,

  $kdc_kpropd_bootstrap_file = $::kerberos::kdc::kpropd::bootstrap::file,

  $echo   = $::kerberos::params::echo,
  $grep   = $::kerberos::params::grep,
  $ktutil = $::kerberos::params::ktutil,
)
{
  $_slave_host_principal  = pick($slave_host_principal, "host/${slave}@${realm}")
  $_master_host_principal = pick($master_host_principal, "host/${master}@${realm}")

  $_slave_kiprop_principal  = pick($slave_kiprop_principal, "kiprop/${slave}@${realm}")
  $_master_kiprop_principal = pick($master_kiprop_principal, "kiprop/${master}@${realm}")

  $command   = "'${kdc_kpropd_bootstrap_file}' '${ensure}' '${realm}' '${slave}' '${master}' '${_slave_host_principal}' '${_master_host_principal}' '${_slave_kiprop_principal}' '${_master_kiprop_principal}'"
  $condition = "${echo} 'list' | ${ktutil} | ${grep} '${_slave_host_principal}' && ${echo} 'list' | ${ktutil} | ${grep} '${_slave_kiprop_principal}'"

  if ($ensure == 'present')
  {
    $unless = $condition
  }
  elsif ($ensure == 'absent')
  {
    $onlyif = $condition
  }

  exec
  { "kerberos::kdc::kpropd::bootstrap::realm::${realm}":
    command => $command,
    onlyif  => $onlyif,
    unless  => $unless,
  }

  if ($manage_dependencies)
  {
    Class['::kerberos::kdc::kpropd::bootstrap'] -> Exec["kerberos::kdc::kpropd::bootstrap::realm::${realm}"]
  }
}
