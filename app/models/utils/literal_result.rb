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
  #   use_defaults - we can fill results with the defaults
  #
  def initialize(action:, controller:, id:)
    @action = action
    @controller = controller
    @id = id
  end

  # concluded?
  # Has the search completed - normally returning a record but it
  # doesn't have to and still considered concluded.
  #
  def concluded?
    id.present?
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

  # self.without_a_search
  #
  # The model does not have any literal search query find any specific record.
  #
  def self.without_a_search
    LiteralResult.new action: '', controller: '', id: nil
  end

  # self.no_record_found
  #
  # completes LiteralResult - no literal match has been found
  # Same as without_a_search but makes more sense when reading code.
  #
  def self.no_record_found
    LiteralResult.new action: '', controller: '', id: nil
  end
end
