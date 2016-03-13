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
class kerberos::kdc::kpropd::service::systemd
(
  $ensure = 'present',
  $source = 'puppet:///modules/kerberos/kdc/kpropd/service/systemd/krb5-kpropd.service',
  $file   = '/lib/systemd/service/krb5-kpropd.service',
  $owner  = 'root',
  $group  = 'root',
  $mode   = '0555',
)
{
  if ($::operatingsystem == 'Ubuntu' and versioncmp($::operatingsystemmajrelease, '15.04') >= 0)
  {
    file
    { $file:
      ensure  => $ensure,
      source  => $source,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
    }
  }
}
