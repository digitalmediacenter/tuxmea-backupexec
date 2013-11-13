# Class backupexec::config
#
# Configure the BackExec Linux Agent
#
class backupexec::config {
    file { '/etc/VRTSralus/ralus.cfg':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('backupexec/ralus.cfg.erb'),
    }
}
