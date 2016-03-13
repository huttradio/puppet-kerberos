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
class kerberos::kdc::kpropd::acl
(
  $ensure              = 'present',
  $manage_dependencies = true,

  $file  = $::kerberos::params::kdc_kpropd_acl_file,
  $owner = $::kerberos::params::kdc_kpropd_acl_owner,
  $group = $::kerberos::params::kdc_kpropd_acl_group,
  $mode  = $::kerberos::params::kdc_kpropd_acl_mode,
)
{
  ::concat
  { $file:
    ensure => $ensure,
    warn   => true,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  ::concat::fragment
  { "${file}::newline":
    target  => $file,
    order   => '01',
    content => '\n',
  }

  if ($manage_dependencies)
  {
    ::Concat[$file] ~> Class['::kerberos::kdc::kpropd::service']
  }
}
