#
# LiteralResult
#
# Wraps up the search results
#
class LiteralResult
  attr_reader :action, :controller, :id, :empty
  def initialize(action:, controller:, id:, empty: false)
    @action = action
    @controller = controller
    @id = id
    @empty = empty
  end

  # Has the results been returned or not?
  #
  def found?
    id.present? || empty
  end

  def redirect_params
    { action: action, controller:  controller, id: id }
  end

  def self.missing
    LiteralResult.new action: '', controller: '', id: nil
  end
end
