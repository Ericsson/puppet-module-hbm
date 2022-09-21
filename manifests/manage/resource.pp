# @param ensure
#   TODO: Add documentation
#
# @param type
#   TODO: Add documentation
#
# @param value
#   TODO: Add documentation
#
# @param options
#   TODO: Add documentation
#
# @param members
#   TODO: Add documentation
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
