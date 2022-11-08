# @param ensure
#   Ensure a group of $name exists or not.
#
define hbm::manage::group (
  Enum['present', 'absent'] $ensure = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'group',
  }
}
