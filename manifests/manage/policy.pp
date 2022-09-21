# @param ensure
#   TODO: Add documentation
#
# @param collection
#   TODO: Add documentation
#
# @param group
#   TODO: Add documentation
#
define hbm::manage::policy (
  Enum['present', 'absent'] $ensure = 'present',
  String[1] $collection             = 'MANDATORY',
  String[1] $group                  = 'MANDATORY',
) {
  hbm { $name:
    ensure     => $ensure,
    provider   => 'policy',
    collection => $collection,
    group      => $group,
  }
}
