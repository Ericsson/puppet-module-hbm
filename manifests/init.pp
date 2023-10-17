# == Class: hbm
#
# Module to manage HBM
#
# @param manage_package
#   If package hbm should be managed.
#
# @param manage_service
#   If service hbm should be managed.
#
# @param service_enable
#   If service hbm should be enabled.
#
# @param service_ensure
#   Ensure of service hbm.
#
# @param collections
#   Hash to be passed to hbm::manage::collection.
#
# @param configs
#   Hash to be passed to hbm::manage::config.
#
# @param groups
#   Hash to be passed to hbm::manage::group.
#
# @param policies
#   Hash to be passed to hbm::manage::policy.
#
# @param resources
#   Hash to be passed to hbm::manage::resource.
#
# @param users
#   Hash to be passed to hbm::manage::user.
#
class hbm (
  Boolean                 $manage_package          = false,
  Boolean                 $manage_service          = true,
  Boolean                 $service_enable          = true,
  Stdlib::Ensure::Service $service_ensure          = 'running',
  Optional[Hash]          $collections             = undef,
  Optional[Hash]          $configs                 = undef,
  Optional[Hash]          $groups                  = undef,
  Optional[Hash]          $policies                = undef,
  Optional[Hash]          $resources               = undef,
  Optional[Hash]          $users                   = undef,
) {
  if $manage_package {
    package { 'package_hbm':
      ensure => installed,
      name   => 'hbm',
    }
  }

  if $manage_service {
    service { 'service_hbm':
      ensure => $service_ensure,
      name   => 'hbm',
      enable => $service_enable,
    }
  }

  if $collections != undef {
    create_resources('hbm::manage::collection', $collections)
  }

  if $configs != undef {
    create_resources('hbm::manage::config', $configs)
  }

  if $groups != undef {
    create_resources('hbm::manage::group', $groups)
  }

  if $policies != undef {
    create_resources('hbm::manage::policy', $policies)
  }

  if $resources != undef {
    create_resources('hbm::manage::resource', $resources)
  }

  if $users != undef {
    create_resources('hbm::manage::user', $users)
  }

  if $manage_package and $manage_service {
    Package['package_hbm'] -> Service['service_hbm']
  }
}
