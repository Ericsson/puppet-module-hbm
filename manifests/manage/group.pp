# @param ensure
#   TODO: Add documentation
#
define hbm::manage::group (
  Enum['present', 'absent'] $ensure = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'group',
  }
}
