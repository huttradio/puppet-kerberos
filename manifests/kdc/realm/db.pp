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
define kerberos::kdc::realm::db
(
  $password,
  $realm  = $title,

  $ensure       = 'present',
  $manage_db    = true,
  $manage_stash = true,

  $kdc_conf_dir_realm          = undef,
  $kdc_stash_file              = undef,

  $kdc_database_dir_realm      = undef,
  $kdc_database_principal_file = undef,

  $echo      = $::kerberos::params::echo,
  $false     = $::kerberos::params::false,
  $kdb5_util = $::kerberos::params::kdb5_util,
  $test      = $::kerberos::params::test,

  $kdc_conf_dir     = $::kerberos::params::kdc_conf_dir,
  $kdc_database_dir = $::kerberos::params::kdc_database_dir,

  $kdc_stash_name  = $::kerberos::params::kdc_stash_name,
  $kdc_stash_owner = $::kerberos::params::kdc_stash_owner,
  $kdc_stash_group = $::kerberos::params::kdc_stash_group,
  $kdc_stash_mode  = $::kerberos::params::kdc_stash_mode,

  $kdc_database_principal_name  = $::kerberos::params::kdc_database_principal_name,
  $kdc_database_principal_owner = $::kerberos::params::kdc_database_principal_owner,
  $kdc_database_principal_group = $::kerberos::params::kdc_database_principal_group,
  $kdc_database_principal_mode  = $::kerberos::params::kdc_database_principal_mode,
)
{
  $_kdc_database_dir_realm      = pick($kdc_database_dir_realm, "${kdc_database_dir}/${realm}")
  $_kdc_database_principal_file = pick($kdc_database_principal_file, "${_kdc_database_dir_realm}/${kdc_database_principal_name}")

  $_kdc_conf_dir_realm          = pick($kdc_conf_dir_realm, "${kdc_conf_dir}/${realm}")
  $_kdc_stash_file              = pick($kdc_stash_file, "${_kdc_conf_dir_realm}/${kdc_stash_name}")

  if ($ensure == 'present')
  {
    if ($manage_db)
    {
      exec
      { "kerberos::kdc::realm::db::${realm}":
        command => "${kdb5_util} create -r '${realm}' -P '${password}'",
        creates => $_kdc_database_principal_file,
      }

      exec
      { "kerberos::kdc::realm::db::check::${realm}":
        command => "${echo} 'Unable to find database for ${realm} after creating it' && ${false}",
        unless  => "${test} -f '${_kdc_database_principal_file}'",
      }

      file
      { $_kdc_database_principal_file:
        ensure => 'file',
        owner  => $kdc_database_principal_owner,
        group  => $kdc_database_principal_group,
        mode   => $kdc_database_principal_mode,
      }

      Exec["kerberos::kdc::realm::db::${realm}"] -> Exec["kerberos::kdc::realm::db::check::${realm}"] -> File[$_kdc_database_principal_file]

      if ($manage_dependencies)
      {
        ::Kerberos::Kdc::Realm::Dir[$realm] -> Exec["kerberos::kdc::realm::db::${realm}"]
      }
    }

    if ($manage_stash)
    {
      exec
      { "kerberos::kdc::realm::stash::${realm}":
        command => "${kdb5_util} stash -r '${realm}' -f '${_kdc_stash_file}'",
        creates => $_kdc_stash_file,
      }

      exec
      { "kerberos::kdc::realm::stash::check::${realm}":
        command => "${echo} 'Unable to find stash for ${realm} after creating it' && ${false}",
        unless  => "${test} -f '${_kdc_stash_file}'",
      }

      file
      { $_kdc_stash_file:
        ensure => 'file',
        owner  => $kdc_stash_owner,
        group  => $kdc_stash_group,
        mode   => $kdc_stash_mode,
      }

      Exec["kerberos::kdc::realm::stash::${realm}"] -> Exec["kerberos::kdc::realm::stash::check::${realm}"] -> File[$_kdc_stash_file]

      if ($manage_dependencies)
      {
        ::Kerberos::Kdc::Realm::Dir[$realm] -> Exec["kerberos::kdc::realm::stash::${realm}"]
      }
    }
  }
  elsif ($ensure == 'absent')
  {
    if ($manage_db)
    {
      exec
      { "kerberos::kdc::realm::db::${realm}":
        command => "${kdb5_util} destroy -f -r '${realm}'",
        onlyif  => "${test} -f '${_kdc_database_principal_file}'",
      }

      exec
      { "kerberos::kdc::realm::db::check::${realm}":
        command => "${echo} 'Found database for ${realm} after destroying it' && ${false}",
        onlyif  => "${test} -f '${_kdc_database_principal_file}'",
      }

      Exec["kerberos::kdc::realm::db::${realm}"] -> Exec["kerberos::kdc::realm::db::check::${realm}"]
    }

    if ($manage_stash)
    {
      file
      { $_kdc_stash_file:
        ensure => 'absent',
      }
    }
  }
}
