# Class backupexec::service
#
# This class enables the RALUS Service
#
class backupexec::service {
    service { 'VRTSralus.init':
        ensure     => running,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
    }
}
