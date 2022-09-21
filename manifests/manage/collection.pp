# @param ensure
#   TODO: Add documentation
#
define hbm::manage::collection (
  Enum['present', 'absent'] $ensure = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'collection',
  }
}
