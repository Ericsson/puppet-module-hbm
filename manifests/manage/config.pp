# @param ensure
#   TODO: Add documentation
#
define hbm::manage::config (
  Enum['present', 'absent'] $ensure  = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'config',
  }
}
