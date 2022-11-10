# @param ensure
#   Ensure a config of $name exists or not.
#
define hbm::manage::config (
  Enum['present', 'absent'] $ensure  = 'present',
) {
  hbm { $name:
    ensure   => $ensure,
    provider => 'config',
  }
}
