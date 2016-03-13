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
class kerberos::params
{
  case $::osfamily
  {
    'Debian':
    {
      ## Executable locations.
      $cat          = '/bin/cat'
      $grep         = '/bin/grep'
      $kadmin       = '/usr/bin/kadmin'
      $kadmin_local = '/usr/sbin/kadmin.local'
      $kdb5_util    = '/usr/sbin/kdb5_util'
      $klist        = '/usr/bin/klist'
      $kprop        = '/usr/sbin/kprop'
      $kpropd       = '/usr/sbin/kpropd'
      $rm           = '/bin/rm'

      ## Client configuration options.
      $client_package = 'krb5-user'

      $client_conf_file  = '/etc/krb5.conf'
      $client_conf_owner = 'root'
      $client_conf_group = 'root'
      $client_conf_mode  = '0444'

      ## Server configuration options.
      $kdc_package = 'krb5-kdc'
      $kdc_service = 'krb5-kdc'

      $kdc_conf_dir     = '/etc/krb5kdc'
      $kdc_database_dir = '/var/lib/krb5kdc'

      $kdc_conf_file  = "${kdc_conf_dir}/kdc.conf"
      $kdc_conf_owner = 'root'
      $kdc_conf_group = 'root'
      $kdc_conf_mode  = '0444'

      $kdc_keytab_file  = '/etc/krb5.keytab'
      $kdc_keytab_owner = 'root'
      $kdc_keytab_group = 'root'
      $kdc_keytab_mode  = '0400'

      $kdc_stash_file  = "${kdc_conf_dir}/stash"
      $kdc_stash_owner = 'root'
      $kdc_stash_group = 'root'
      $kdc_stash_mode  = '0400'

      $kdc_database      = "${kdc_database_dir}/principal"
      $kdc_database_dump = "${kdc_database_dir}/dump"

      # kpropd configuration options for KDCs.
      $kdc_kpropd_service = 'krb5-kpropd'

      $kdc_kpropd_acl_file        = "${kdc_conf_dir}/kpropd.acl"
      $kdc_kpropd_acl_owner       = 'root'
      $kdc_kpropd_acl_group       = 'root'
      $kdc_kpropd_acl_mode        = '0400'
      $kdc_kpropd_acl_host_prefix = 'host'

      # Admin server configuration options.
      $admin_server_packages = 'krb5-admin-server'
      $admin_server_service  = 'krb5-admin-server'

      $admin_server_conf_dir = '/etc/krb5kdc'

      $admin_server_keytab       = "${admin_server_conf_dir}/kadm5.keytab"
      $admin_server_keytab_owner = 'root'
      $admin_server_keytab_group = 'root'
      $admin_server_keytab_mode  = '0400'

      $admin_server_acl_file  = "${admin_server_conf_dir}/kadm5.acl"
      $admin_server_acl_owner = 'root'
      $admin_server_acl_group = 'root'
      $admin_server_acl_mode  = '0400'
    }

    default:
    {
      fail("Sorry, but kerberos does not support the $::osfamily OS family at this time")
    }
  }

}
