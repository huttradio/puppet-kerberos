# == Class: kerberos
#
# Full description of class kerberos here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { kerberos:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
define kerberos::kdc::conf::realms::realm
(
  $realm  = $name,

  $ensure         = 'present',
  $manage_section = true,

  # kerberos::kdc::conf::realm parameters.
  $acl_file                     = $::kerberos::params::kdc_kadmin_server_acl_file,
  $admin_keytab                 = "FILE:${::kerberos::params::kdc_kadmin_server_keytab_file}",
  $database_module              = undef,
  $database_name                = undef, # See the define body
  $default_principal_expiration = undef,
  $default_principal_flags      = undef,
  $dict_file                    = undef,
  $host_based_services          = undef,
  $iprop_enable                 = undef,
  $iprop_master_ulogsize        = undef,
  $iprop_slave_poll             = undef,
  $iprop_port                   = undef,
  $iprop_resync_timeout         = undef,
  $iprop_logfile                = undef,
  $kadmind_port                 = undef,
  $key_stash_file               = undef, # See the define body
  $kdc_ports                    = undef,
  $kdc_tcp_ports                = undef,
  $master_key_name              = undef,
  $master_key_type              = undef,
  $max_life                     = undef,
  $max_renewable_life           = undef,
  $no_host_referral             = undef,
  $des_crc_session_supported    = undef,
  $reject_bad_transit           = undef,
  $restrict_anonymous_to_tgt    = undef,
  $supported_enctypes           = undef,
  $sunw_dbprop_enable           = undef,
  $sunw_dbprop_master_ulogsize  = undef,
  $sunw_dbprop_slave_poll       = undef,

  $kdc_conf_file = $::kerberos::kdc::conf::file,

  $kdc_conf_dir                = $::kerberos::params::kdc_conf_dir,
  $kdc_stash_name              = $::kerberos::params::kdc_stash_name,
  $kdc_database_dir            = $::kerberos::params::kdc_database_dir,
  $kdc_database_principal_name = $::kerberos::params::kdc_database_principal_name,
)
{
  if ($ensure == 'present')
  {
    $_database_name  = pick($database_name, "${kdc_database_dir}/${realm}/${kdc_database_principal_name}")
    $_key_stash_file = pick($key_stash_file, "${kdc_conf_dir}/${realm}/${kdc_stash_name}")

    if ($manage_section)
    {
      include ::kerberos::kdc::conf::realms
    }

    ::concat::fragment
    { "${kdc_conf_file}::realms::${realm}":
      target  => $kdc_conf_file,
      order   => "03-${realm}",
      content => template('kerberos/kdc/conf/realms/realm.erb'),
    }
  }
}

