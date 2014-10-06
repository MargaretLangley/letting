####
#
# Patch
#
# Updating data which is incorrect. It overwrites original
# rows with patch rows as required.
#
# Patch is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
####
#
class Patch
  attr_reader :patch
  def initialize(patch:)
    @patch = patch
  end

  def cleanse(originals:)
    originals.map! do |original|
      stand_in = patch.find { |patch| match original, patch }
      stand_in ? stand_in : original
    end
  end

  def match _original, _patch
    warn 'override match method'
    false
  end
end
