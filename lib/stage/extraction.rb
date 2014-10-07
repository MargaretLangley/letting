####
#
# Extraction
#
# adding data which are missing. It applies them into the correct position.
#
# Extraction is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
####
#
class Extraction
  attr_reader :extracts
  def initialize(extracts:)
    @extracts = extracts
  end

  def cleanse(originals:)
    extracts.map! do |extract|
      originals.delete_if { |original| match original, extract }
    end
  end

  def match _original, _extract
    warn 'override match method'
    false
  end
end
