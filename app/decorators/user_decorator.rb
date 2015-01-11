require_relative '../../lib/modules/method_missing'

###
#
# UserDecorator
#
# Adds display logic to the user business object.
#
# rubocop: disable Style/TrivialAccessors
##
#
class UserDecorator
  include ActionView::Helpers::NumberHelper
  include MethodMissing

  def user
    @source
  end

  def initialize user
    @source = user
  end

  def admin
    user.admin? ? 'Yes' : 'No'
  end
end
