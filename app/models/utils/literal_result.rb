#
# LiteralResult
#
# Wraps up the search results
#
class LiteralResult
  attr_reader :action, :controller, :id, :empty

  # initialize
  # args:
  #   action: - rest action
  #   controller - controller the action is called on
  #   id - record id returned
  #   empty - return you have not found anything when you have actually
  #           returned id
  #
  def initialize(action:, controller:, id:, empty: false)
    @action = action
    @controller = controller
    @id = id
    @empty = empty
  end

  # concluded?
  # Has the search completed - normally returning a record but it
  # doesn't have to and still considered concluded.
  #
  def concluded?
    id.present? || empty
  end

  # redirect_params
  # returns - action, controller, id - enough information to redirect
  #
  def redirect_params
    { action: action, controller:  controller, id: id }
  end

  # self.missing
  #
  # Empty LiteralResult - will return found of false
  #
  def self.missing
    LiteralResult.new action: '', controller: '', id: nil
  end
end
