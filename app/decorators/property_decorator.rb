require_relative '../../lib/modules/method_missing'
####
#
# PropertyDecorator
#
# Adds behaviour to the property object
#
# Used when the property has need for behaviour outside of the core
# of the model. Specifically for display information.
#
####
#
class PropertyDecorator
  include MethodMissing
  attr_reader :source

  def initialize property
    @source = property
  end

  def client_ref
    client && client.human_ref
  end

  def agent_name
    if source.agent.authorized?
      source.agent.entities.full_name
    else
      'None'
    end
  end

  def agent_address_lines
    if source.agent.authorized?
      source.agent.address.text
    else
      ['-']
    end
  end
end
