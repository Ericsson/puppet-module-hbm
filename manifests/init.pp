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

  if is_string($manage_package) {
    $manage_package_real = str2bool($manage_package)
  } else {
    $manage_package_real = $manage_package
  }
  validate_bool($manage_package_real)

  if is_string($manage_service) {
    $manage_service_real = str2bool($manage_service)
  } else {
    $manage_service_real = $manage_service
  }
  validate_bool($manage_service_real)

  if is_string($service_enable) {
    $service_enable_real = str2bool($service_enable)
  } else {
    $service_enable_real = $service_enable
  }
  validate_bool($service_enable_real)

  validate_re($service_ensure, ['^running$', '^stopped$'], 'hbm::service_ensure is invalid and does not match the regex.')

  if is_string($collections_hiera_merge) {
    $collections_hiera_merge_real = str2bool($collections_hiera_merge)
  } else {
    $collections_hiera_merge_real = $collections_hiera_merge
  }
  validate_bool($collections_hiera_merge_real)

  if is_string($configs_hiera_merge) {
    $configs_hiera_merge_real = str2bool($configs_hiera_merge)
  } else {
    $configs_hiera_merge_real = $configs_hiera_merge
  }
  validate_bool($configs_hiera_merge_real)

  if is_string($groups_hiera_merge) {
    $groups_hiera_merge_real = str2bool($groups_hiera_merge)
  } else {
    $groups_hiera_merge_real = $groups_hiera_merge
  }
  validate_bool($groups_hiera_merge_real)

  if is_string($policies_hiera_merge) {
    $policies_hiera_merge_real = str2bool($policies_hiera_merge)
  } else {
    $policies_hiera_merge_real = $policies_hiera_merge
  }
  validate_bool($policies_hiera_merge_real)

  if is_string($resources_hiera_merge) {
    $resources_hiera_merge_real = str2bool($resources_hiera_merge)
  } else {
    $resources_hiera_merge_real = $resources_hiera_merge
  }
  validate_bool($resources_hiera_merge_real)

  if is_string($users_hiera_merge) {
    $users_hiera_merge_real = str2bool($users_hiera_merge)
  } else {
    $users_hiera_merge_real = $users_hiera_merge
  }
  validate_bool($users_hiera_merge_real)

  if $manage_package_real {
    package { 'package_hbm':
      ensure => installed,
      name   => 'hbm',
    }
  }

  if $manage_service_real {
    service { 'service_hbm':
      ensure => $service_ensure,
      name   => 'hbm',
      enable => $service_enable_real,
    }
  }

  if $collections != undef {
    if $collections_hiera_merge_real == true {
      $collections_real = hiera_hash('hbm::collections')
    } else {
      $collections_real = $collections
    }
    validate_hash($collections_real)
    create_resources('hbm::manage::collection', $collections_real)
  }

  if $configs != undef {
    if $configs_hiera_merge_real == true {
      $configs_real = hiera_hash('hbm::configs')
    } else {
      $configs_real = $configs
    }
    validate_hash($configs_real)
    create_resources('hbm::manage::config', $configs_real)
  }

  if $groups != undef {
    if $groups_hiera_merge_real == true {
      $groups_real = hiera_hash('hbm::groups')
    } else {
      $groups_real = $groups
    }
    validate_hash($groups_real)
    create_resources('hbm::manage::group', $groups_real)
  }

  if $policies != undef {
    if $policies_hiera_merge_real == true {
      $policies_real = hiera_hash('hbm::policies')
    } else {
      $policies_real = $policies
    }
    validate_hash($policies_real)
    create_resources('hbm::manage::policy', $policies_real)
  }

  if $resources != undef {
    if $resources_hiera_merge_real == true {
      $resources_real = hiera_hash('hbm::resources')
    } else {
      $resources_real = $resources
    }
    validate_hash($resources_real)
    create_resources('hbm::manage::resource', $resources_real)
  }

  if $users != undef {
    if $users_hiera_merge_real == true {
      $users_real = hiera_hash('hbm::users')
    } else {
      $users_real = $users
    }
    validate_hash($users_real)
    create_resources('hbm::manage::user', $users_real)
  }

  if $manage_package_real and $manage_service_real {
    Package['package_hbm'] -> Service['service_hbm']
  }
}
