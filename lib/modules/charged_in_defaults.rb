###
#
# ChargedInDefaults
#
# Constants relating to ChargedIn
# Most charges are in Advance or Arrears - Mid-term is only used in
# the legacy application it was a charge that was due around half way
# into the service period.
#
# LEGACY = the previous application
# MODERN = this application
#
####
module ChargedInDefaults
  LEGACY_ARREARS = '0'
  LEGACY_ADVANCE = '1'
  LEGACY_MID_TERM = 'M'

  MODERN_ARREARS = 1
  MODERN_ADVANCE = 2
end
