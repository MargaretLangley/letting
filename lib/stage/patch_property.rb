require_relative 'patch'

####
#
# PatchProperty
#
# Updating property data which is incorrect. It overwrites property
# rows with patch rows as required.
#
# PatchProperty is part of the staging process - specifically it is called by
# property.rake
#
####
#
class PatchProperty < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref]
  end
end
