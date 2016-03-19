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
class kerberos::kdc::kpropd::bootstrap
(
  $ensure              = 'present',

  $file  = $::kerberos::params::kdc_kpropd_bootstrap_file,
  $owner = $::kerberos::params::kdc_kpropd_bootstrap_owner,
  $group = $::kerberos::params::kdc_kpropd_bootstrap_group,
  $mode  = $::kerberos::params::kdc_kpropd_bootstrap_mode,

  $kdc_keytab_file        = $::kerberos::params::kdc_keytab_file,
  $kdc_database_dir       = $::kerberos::params::kdc_database_dir,
  $kdc_database_dump_name = $::kerberos::params::kdc_database_dump_name,
)
{
  file
  { $file:
    ensure  => $ensure,
    content => template('kerberos/kdc/kpropd/bootstrap/kpropd-bootstrap.erb'),
    owner   => $owner,
    group   => $group,
    mode    => $mode,
  }
}
