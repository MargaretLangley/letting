#
# LiteralResult
#
# Wraps up the search results
#
class LiteralResult
  attr_reader :action, :controller, :id, :completes

  # initialize
  # args:
  #   action: - rest action
  #   controller - controller the action is called on
  #   id - record id returned
  #   completes - return you have not found anything when you have actually
  #           returned id
  #
  def initialize(action:, controller:, id:, completes: false)
    @action = action
    @controller = controller
    @id = id
    @completes = completes
  end

  # concluded?
  # Has the search completed - normally returning a record but it
  # doesn't have to and still considered concluded.
  #
  def concluded?
    id.present? || completes
  end

  # The search not only completed but it also found a result.
  #
  def found?
    id.present?
  end

  # redirect_params
  # returns - action, controller, id - enough information to redirect
  #
  def redirect_params
    { action: action, controller:  controller, id: id }
  end

  # self.missing
  #
  # completes LiteralResult - will return found of false
  #
  def self.missing
    LiteralResult.new action: '', controller: '', id: nil
  end
end
