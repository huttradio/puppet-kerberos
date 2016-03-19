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
define kerberos::kdc::principal
(
  $principal = regsubst($title, '^(.*)@(.*)$', '\1'),
  $realm     = regsubst($title, '^(.*)@(.*)$', '\2'),

  $ensure              = 'present',
  $manage_principal    = true,
  $manage_keytab       = false,
  $manage_dependencies = true,

  # For details on options see this:
  # http://web.mit.edu/Kerberos/krb5-1.12/doc/admin/admin_commands/kadmin_local.html#commands
  $randkey  = true,
  $password = undef,
  $options  = {},

  $kdc_keytab_file = $::kerberos::params::kdc_keytab_file,

  $grep         = $::kerberos::params::grep,
  $kadmin_local = $::kerberos::params::kadmin_local,
  $klist        = $::kerberos::params::klist,
)
{
  if ($ensure == 'present')
  {
    $_options = kerberos_kdc_principal_options_encode($randkey, $pw, $options)

    if ($manage_principal)
    {
      exec
      { "::kerberos::kdc::principal::principal::${principal}":
        command => "${kadmin_local} -r ${realm} -q 'add_principal ${_options} ${principal}'",
        unless  => "${kadmin_local} -r ${realm} -q 'list_principals ${principal}' | ${grep} '${principal}'",
      }
    }

    if ($manage_keytab)
    {
      exec
      { "::kerberos::kdc::principal::keytab::${principal}":
        command => "${kadmin_local} -r ${realm} -q 'ktadd -k ${kdc_keytab_file} ${principal}'",
        unless  => "${klist} -ke '${kdc_keytab_file}' | ${grep} '${principal}'",
      }

      if ($manage_principal)
      {
        Exec["::kerberos::kdc::principal::principal::${principal}"] -> Exec["::kerberos::kdc::principal::keytab::${principal}"]
      }
    }
  }
  elsif ($ensure == 'absent')
  {
    if ($manage_principal)
    {
      exec
      { "::kerberos::kdc::principal::principal::${principal}":
        command => "${kadmin_local} -r ${realm} -q 'delete_principal -force ${principal}'",
        onlyif  => "${kadmin_local} -r ${realm} -q 'list_principals ${principal}' | ${grep} '${principal}'",
      }
    }

    if ($manage_keytab)
    {
      exec
      { "::kerberos::kdc::principal::keytab::${principal}":
        command => "${kadmin_local} -r ${realm} -q 'ktremove -k ${kdc_keytab_file} ${principal} all'",
        onlyif  => "${klist} -ke '${kdc_keytab_file}' | ${grep} '${principal}'",
      }
    }
  }

  if ($manage_dependencies)
  {
    if ($manage_principal)
    {
      ::Kerberos::Kdc::Realm[$realm]                   -> Exec["::kerberos::kdc::principal::principal::${principal}"]
      Class['::kerberos::kdc::kadmin_server::service'] -> Exec["::kerberos::kdc::principal::principal::${principal}"]
    }

    if ($manage_keytab)
    {
      ::Kerberos::Kdc::Realm[$realm]                   -> Exec["::kerberos::kdc::principal::keytab::${principal}"]
      Class['::kerberos::kdc::kadmin_server::service'] -> Exec["::kerberos::kdc::principal::keytab::${principal}"]
    }
  }
}
