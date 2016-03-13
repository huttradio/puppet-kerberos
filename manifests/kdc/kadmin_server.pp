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
class kerberos::kdc::kadmin_server
(
  $ensure             = 'present',

  $manage_package      = true,
  $manage_service      = true,
  $manage_default_acl  = true,
  $manage_dependencies = true,

  $acl_file = $::kerberos::params::kdc_kadmin_server_acl_file,
) inherits kerberos::params
{
  if ($manage_package)
  {
    class
    { '::kerberos::kdc::kadmin_server::package':
      ensure => $ensure,
    }
  }

  if ($manage_service)
  {
    class
    { '::kerberos::kdc::kadmin_server::service':
      ensure              => $ensure,
      manage_dependencies => $manage_dependencies,
    }
  }

  if ($manage_default_acl)
  {
    ::kerberos::kdc::kadmin_server::acl
    { $acl_file:
      ensure              => $ensure,
      manage_dependencies => $manage_dependencies,
    }
  }
}
