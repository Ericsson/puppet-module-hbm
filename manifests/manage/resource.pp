# @param ensure
#   Ensure a resource of $name exists or not.
#
# @param type
#   Resource value.
#
# @param value
#   Resource value.
#
# @param options
#   Any valid options for the specific resource value.
#
# @param members
#   Collection names where resource will be applied to.
#
define hbm::manage::resource (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String[1]] $type         = undef,
  Optional[String[1]] $value        = undef,
  Array $options                    = [],
  Array $members                    = [],
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'resource',
    type     => $type,
    value    => $value,
    options  => $options,
    members  => $members,
  }
}
