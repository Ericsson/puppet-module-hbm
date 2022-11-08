# @param ensure
#   Ensure a collection of $name exists or not.
#
define hbm::manage::collection (
  Enum['present', 'absent'] $ensure = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'collection',
  }
}
