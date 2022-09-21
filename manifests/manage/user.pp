# @param ensure
#   TODO: Add documentation
#
# @param members
#   TODO: Add documentation
#
define hbm::manage::user (
  Enum['present', 'absent'] $ensure = 'present',
  Array $members                    = [],
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'user',
    members  => $members,
  }
}
