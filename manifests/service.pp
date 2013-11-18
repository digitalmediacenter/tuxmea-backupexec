# Class backupexec::service
#
# This class enables the RALUS Service
#
class backupexec::service {
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
  }
}
