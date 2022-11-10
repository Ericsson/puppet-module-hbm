# @param ensure
#   Ensure a policy of $name exists or not.
#
# @param collection
#   To which collection this policy applies to.
#
# @param group
#   To which group this policy is applied.
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
