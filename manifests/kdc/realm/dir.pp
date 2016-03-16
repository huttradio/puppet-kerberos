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
define kerberos::kdc::realm::dir
(
  $realm  = $title,

  $ensure              = 'present',
  $manage_conf_dir     = true,
  $manage_database_dir = true,

  $kdc_conf_dir_realm     = undef,
  $kdc_database_dir_realm = undef,

  $kdc_conf_dir       = $::kerberos::params::kdc_conf_dir,
  $kdc_conf_dir_owner = $::kerberos::params::kdc_conf_dir_owner,
  $kdc_conf_dir_group = $::kerberos::params::kdc_conf_dir_group,
  $kdc_conf_dir_mode  = $::kerberos::params::kdc_conf_dir_mode,

  $kdc_database_dir       = $::kerberos::params::kdc_database_dir,
  $kdc_database_dir_owner = $::kerberos::params::kdc_database_dir_owner,
  $kdc_database_dir_group = $::kerberos::params::kdc_database_dir_group,
  $kdc_database_dir_mode  = $::kerberos::params::kdc_database_dir_mode,
)
{
  $_kdc_conf_dir_realm     = pick($kdc_conf_dir_realm, "${kdc_conf_dir}/${realm}")
  $_kdc_database_dir_realm = pick($kdc_database_dir_realm, "${kdc_database_dir}/${realm}")

  if ($ensure == 'present')
  {
    $directory_ensure = 'directory'
  }
  else
  {
    $directory_ensure = $ensure
  }

  if ($manage_conf_dir)
  {
    file
    { $_kdc_conf_dir_realm:
      ensure => $directory_ensure,
      owner  => $kdc_conf_dir_owner,
      group  => $kdc_conf_dir_group,
      mode   => $kdc_conf_dir_mode,
    }
  }

  if ($manage_database_dir)
  {
    file
    { $_kdc_database_dir_realm:
      ensure => $directory_ensure,
      owner  => $kdc_database_dir_owner,
      group  => $kdc_database_dir_group,
      mode   => $kdc_database_dir_mode,
    }
  }
}
