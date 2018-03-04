# == Class: bitcoind::install
#
# Installs packages
#
# == Actions:
#
# * Adds the Bitcoin or Bitcoin Classic Apt PPA to the system
# * Installs the bitcoind package
# * Optionally installs the bitcoin-qt package
#
# === Authors:
#
# Craig Watson <craig@cwatson.org>
#
# === Copyright:
#
# Copyright (C) Craig Watson
# Published under the Apache License v2.0
#
class bitcoind::install {

  apt::ppa { 'puppet_bitcoin_ppa':
    ensure => $::bitcoind::ppa,
  }

  exec { 'puppet_uninstall_bitcoind':
    command     => 'puppet resource service bitcoind ensure=stopped;puppet resource package bitcoind ensure=absent',
    path        => ['/bin/','/sbin/','/usr/bin/','/usr/sbin/','/usr/local/bin/','/opt/puppetlabs/bin/'],
    notify      => Exec['puppet_bitcoind_clean'],
    refreshonly => true,
  }

  exec { 'puppet_bitcoind_clean':
    command     => '/bin/rm /usr/bin/bitcoin*',
    onlyif      => '/bin/ls -1 /usr/bin | grep -q bitcoin',
    refreshonly => true,
  }

  package { 'bitcoind':
    ensure  => present,
    require => Exec['apt_update'],
  }

}
