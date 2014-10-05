
class PatchClient
  attr_reader :input, :patch
  def initialize(input:, patch:)
    @input = input
    @patch = patch
  end

  def cleanse
    patched = input.map! do |item|
      matched = patch.find do |patch|
        item[:human_ref] == patch[:human_ref]
      end
      if matched
        matched
      else
        item
      end
    end
  end
end