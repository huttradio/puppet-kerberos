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
class kerberos::kdc::kpropd::service
(
  $ensure  = 'present',
  $service = $::kerberos::params::kdc_kpropd_service,
) inherits kerberos::params
{
  if ($ensure == 'present')
  {
    $service_ensure = 'running'
  }
  elsif ($ensure == 'absent')
  {
    $service_ensure = 'stopped'
  }
  else
  {
    $service_ensure = $ensure
  }

  # Install the init.d and/or system.d scripts for kpropd, if there isn't
  # one already.
  class
  { '::kerberos::kdc::kpropd::service::init_d':
    ensure => $ensure,
  }

  class
  { '::kerberos::kdc::kpropd::service::systemd':
    ensure => $ensure,
  }

  contain ::kerberos::kdc::kpropd::service::init_d
  contain ::kerberos::kdc::kpropd::service::systemd

  # Manage the kpropd service.
	service
	{ $service:
		ensure	=> $service_ensure,
	}

  if ($ensure == 'present')
  {
    Class['::kerberos::kdc::kpropd::service::init_d']  -> Service[$service]
    Class['::kerberos::kdc::kpropd::service::systemd'] -> Service[$service]
  }
  elsif ($ensure == 'absent')
  {
    Service[$service] -> Class['::kerberos::kdc::kpropd::service::init_d']
    Service[$service] -> Class['::kerberos::kdc::kpropd::service::systemd']
  }
}
