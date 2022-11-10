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
# @param collections_hiera_merge
#   If the module should merge `$collections` from different levels in hiera.
#
# @param configs_hiera_merge
#   If the module should merge `$configs` from different levels in hiera.
#
# @param groups_hiera_merge
#   If the module should merge `$groups` from different levels in hiera.
#
# @param policies_hiera_merge
#   If the module should merge `$policies` from different levels in hiera.
#
# @param resources_hiera_merge
#   If the module should merge `$resources` from different levels in hiera.
#
# @param users_hiera_merge
#   If the module should merge `$users` from different levels in hiera.
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
  Boolean                 $collections_hiera_merge = false,
  Boolean                 $configs_hiera_merge     = false,
  Boolean                 $groups_hiera_merge      = false,
  Boolean                 $policies_hiera_merge    = false,
  Boolean                 $resources_hiera_merge   = false,
  Boolean                 $users_hiera_merge       = false,
) {
  $dockerversion = '1.12.0'

  if versioncmp($facts['docker_version'], $dockerversion) < 0 {
    fail("HBM requires Docker Engine version >=${dockerversion}. Your version is ${facts['docker_version']}.")
  }

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
    if $collections_hiera_merge == true {
      $collections_real = hiera_hash('hbm::collections')
    } else {
      $collections_real = $collections
    }
    create_resources('hbm::manage::collection', $collections_real)
  }

  if $configs != undef {
    if $configs_hiera_merge == true {
      $configs_real = hiera_hash('hbm::configs')
    } else {
      $configs_real = $configs
    }
    create_resources('hbm::manage::config', $configs_real)
  }

  if $groups != undef {
    if $groups_hiera_merge == true {
      $groups_real = hiera_hash('hbm::groups')
    } else {
      $groups_real = $groups
    }
    create_resources('hbm::manage::group', $groups_real)
  }

  if $policies != undef {
    if $policies_hiera_merge == true {
      $policies_real = hiera_hash('hbm::policies')
    } else {
      $policies_real = $policies
    }
    create_resources('hbm::manage::policy', $policies_real)
  }

  if $resources != undef {
    if $resources_hiera_merge == true {
      $resources_real = hiera_hash('hbm::resources')
    } else {
      $resources_real = $resources
    }
    create_resources('hbm::manage::resource', $resources_real)
  }

  if $users != undef {
    if $users_hiera_merge == true {
      $users_real = hiera_hash('hbm::users')
    } else {
      $users_real = $users
    }
    create_resources('hbm::manage::user', $users_real)
  }

  if $manage_package and $manage_service {
    Package['package_hbm'] -> Service['service_hbm']
  }
}
