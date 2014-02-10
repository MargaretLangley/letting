require_relative '../../lib/modules/method_missing'

class AddressDecorator
  include MethodMissing

  def initialize address
    @address = address
  end

  def district_visiblity
    js_hooks + (@address.district? ? '' : 'revealable')
  end

  def add_district_visiblity
    js_hooks + (@address.district? ? 'revealable' : '')
  end

  def nation_visiblity
    js_hooks + (@address.nation? ? '' : 'revealable')
  end

  def add_nation_visiblity
    js_hooks + (@address.nation? ? 'revealable' : '')
  end

  private

  def js_hooks
    ' js-togglable js-clear '
  end

end
