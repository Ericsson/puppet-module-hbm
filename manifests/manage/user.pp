# @param ensure
#   Ensure a user of $name exists or not.
#
# @param members
#   Collection names where resource will be applied to.
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
