require_relative 'patch'

####
#
# PatchClient
#
# Updating client data which is incorrect. It overwrites client
# rows with patch rows as required.
#
# PatchClient is part of the staging process - specifically it is called by
# clients.rake
#
####
#
class PatchClient < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref]
  end
end
