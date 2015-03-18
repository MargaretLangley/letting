#
# LiteralResult
#
# Wraps up the search results
#
class LiteralResult
  attr_reader :action, :controller, :id, :no_search

  # initialize
  # args:
  #   action: - rest action
  #   controller - controller the action is called on
  #   id - record id returned
  #   no_search - do not search
  #
  def initialize(action:, controller:, id:, no_search: false)
    @action = action
    @controller = controller
    @id = id
    @no_search = no_search
  end

  # The search not only completed but it also found a result.
  #
  def found?
    return false if no_search

    id.present?
  end

  # to_params
  # returns - action, controller, id - enough information to redirect
  #
  def to_params
    params = { action: action, controller:  controller }
    params.merge!(id: id) if id
    params
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
    LiteralResult.new action: '', controller: '', id: nil, no_search: true
  end
end
