require_relative 'patch'

####
#
# PatchAddress2
#
# Updating address2 data which is incorrect. It overwrites address
# rows with patch rows as required.
#
# PatchAddress2 is part of the staging process - specifically it is called by
# clients.rake
#
####
#
class PatchAddress2 < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref]
  end
end
