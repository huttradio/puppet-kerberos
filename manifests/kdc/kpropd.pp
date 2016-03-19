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
class kerberos::kdc::kpropd
(
  $ensure = 'present',

  $manage_acl          = true,
  $manage_service      = true,
  $manage_bootstrap    = true,
  $manage_dependencies = true,
)
{
  if ($manage_acl)
  {
    class
    { '::kerberos::kdc::kpropd::acl':
      ensure              => $ensure,
      manage_dependencies => $manage_dependencies,
    }
  }

  if ($manage_service)
  {
    class
    { '::kerberos::kdc::kpropd::service':
      ensure              => $ensure,
      manage_dependencies => $manage_dependencies,
    }
  }

  if ($manage_bootstrap)
  {
    class
    { '::kerberos::kdc::kpropd::bootstrap':
      ensure => $ensure,
    }
  }
}
