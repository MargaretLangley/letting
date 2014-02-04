require_relative '../../lib/modules/method_missing'

class AddressDecorator
  include MethodMissing

  def initialize address
    @address = address
  end

  def district_visiblity
    js_hooks + (@address.district.present? ? '' : 'revealable')
  end

  def add_district_visiblity
    js_hooks + (@address.district.present? ? 'revealable' : '')
  end

  private

  def js_hooks
    ' js-togglable js-clear '
  end

end
