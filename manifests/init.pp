# Class backupexec
#
# This class installs and configures a Symantec BackupExec agent on Linux
#
# For configuration options see: http://www.symantec.com/business/support/index?page=content&id=HOWTO51791
#
class backupexec (
  $advertisement_port           = 6101,
  $agent_config                 = 0,
  $vxbsa_level                  = 0,
  $advertise_all                = 1,
  $advertise_now                = 0,
  $advertisement_purge          = 0,
  $advertising_disabled         = 0,
  $advertising_interval_minutes = 240,
  $agent_directory_list         = [ $::fqdn, ],
  $auto_discovery_enabled       = 1,
  $rant_ndmp_debug_level        = 0,
  $disable_ofo                  = 0,
  $encoder                      = '',
  $show_tsafs                   = 0,
  $vfm_path                     = '/opt/VRTSralus/VRTSvxms',
  $disable_rmal                 = 0,
  $dnsquery_timeout             = 5000,
  $systemfs_type_exclude        = [ 'devpts', 'proc', 'sysfs', 'rpc_pipefs', 'tmpfs', 'ftp', ],
  $system_exclude               = [ '/dev/*.*', '/proc/*.*', '/sys/*.*', ],
  $package_name                 = $backupexec::params::pkgname,
  $package_ensure               = 'present',
) inherits backupexec::params {

  validate_re($advertisement_port, '^[0-9]+$', 'A port number can only contain numbers... - advertisement_port')
  validate_re($dnsquery_timeout, '^[0-9]+$', 'dnsquery_timeout can only be a interger value')
  validate_re($agent_config, '^[01]$', 'agent_config can only be 0 or 1')
  validate_re($advertise_all, '^[01]$', 'advertise_all can only be 0 or 1')
  validate_re($advertise_now, '^[01]$', 'advertise_now can only be 0 or 1')
  validate_re($advertisement_purge, '^[01]$', 'advertisement_purge can only be 0 or 1')
  validate_re($advertising_disabled, '^[01]$', 'advertising_disabled can only be 0 or 1')
  validate_re($auto_discovery_enabled, '^[01]$', 'auto_discovery_enabled can only be 0 or 1')
  validate_re($disable_ofo, '^[01]$', 'disable_ofo can only be 0 or 1')
  validate_re($show_tsafs, [ '^[01]$', '^$', ], 'show_tsafs can only be empty,0 or 1')
  validate_re($disable_rmal, '^[01]$', 'disable_rmal can only be 0 or 1')
  validate_re($rant_ndmp_debug_level, '^[012]$', 'rant_ndmp_debug_level can only be 0,1 or 2')
  validate_re($vxbsa_level, '^[056]$', 'vxbsa_level can only be 0,5 or 6')
  validate_absolute_path($vfm_path)
  validate_array($agent_directory_list)
  validate_array($system_exclude)
  validate_array($systemfs_type_exclude)
  if ! is_integer($advertising_interval_minutes) or ($advertising_interval_minutes < 1 or $advertising_interval_minutes > 720) {
    fail('advertising_interval_minutes can only be a integer value between 1 and 720')
  }

  group { 'beoper':
    ensure => present,
  }
  user { 'beuser':
    ensure  => present,
    gid     => '0',
    groups  => 'beoper',
    require => Group['beoper']
  }

  package { $package_name:
    ensure  => $package_ensure,
    require => User['beuser'],
  }

  file { '/etc/VRTSralus/ralus.cfg':
    ensure  => file,
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0644',
    content => template('backupexec/ralus.cfg.erb'),
    require => Package[$package_name],
  }

  file { '/etc/init.d/VRTSralus.init':
    ensure => 'link',
    target => '/opt/VRTSralus/bin/VRTSralus.init',
    before => Service['VRTSralus.init'],
  }

  service { 'VRTSralus.init':
    ensure     => running,
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    pattern    => '/opt/VRTSralus/bin/beremote',
    require    => Package[$package_name],
  }

  file { '/opt/VRTSralus/data':
    ensure  => 'directory',
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0770',
    require => Package[$package_name],
  }
}
