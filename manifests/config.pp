# Class backupexec::config
#
# Configure the BackExec Linux Agent
#
class backupexec::config {
    group { 'beoper':
        ensure => present,
    }
    user { 'beuser':
        ensure  => present,
        gid     => '0',
        groups  => 'beoper',
        require => Group['beoper']
    }
    file { '/etc/VRTSralus/ralus.cfg':
        ensure  => file,
        owner   => 'beuser',
        group   => 'beoper',
        mode    => '0644',
        content => template('backupexec/ralus.cfg.erb'),
    }
}
