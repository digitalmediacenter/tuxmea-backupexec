# Class backupexec::install
#
# Install Symantec BackeExec Agent
#
class backupexec::install {
  package { $backupexec::params::pkgname:
    ensure  => present,
  }
  file { '/opt/VRTSralus/data':
    ensure  => 'directory',
    owner   => 'beuser',
    group   => 'beoper',
    mode    => '0770',
    require => Package[$backupexec::params::pkgname],
  }
}
