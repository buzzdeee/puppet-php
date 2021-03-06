# Install the development package with headers for PHP
#
# === Parameters
#
# [*ensure*]
#   The PHP ensure of PHP dev to install
#
# [*package*]
#   The package name for the PHP development files
#
class php::dev(
  $ensure  = $::php::ensure,
  $package = "${::php::package_prefix}${::php::params::dev_package_suffix}",
) inherits ::php::params {

  if $caller_module_name != $module_name {
    warning('php::dev is private')
  }

  validate_string($ensure)
  validate_string($package)

  # On FreeBSD there is no 'devel' package.
  $real_package = $::osfamily ? {
    'FreeBSD' => [],
    'OpenBSD' => [],
    default   => $package,
  }

  if $::operatingsystem == 'Ubuntu' {
    ensure_packages(["${php::globals::package_prefix}xml"], {
      ensure  => present,
      require => Class['::apt::update'],
    })

    package { $real_package:
      ensure  => $ensure,
      require => Class['::php::packages'],
    }
  } else {
    package { $real_package:
      ensure  => $ensure,
      require => Class['::php::packages'],
    }
  }
}
