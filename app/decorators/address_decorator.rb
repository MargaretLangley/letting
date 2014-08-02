require_relative '../../lib/modules/method_missing'

class AddressDecorator
  include MethodMissing

  def initialize address
    @address = address
  end

  def district_visiblity
    @address.district? ? '' : 'js-revealable'
  end

  def add_district_visiblity
    @address.district? ? 'js-revealable' : ''
  end

  def nation_visiblity
    @address.nation? ? '' : 'js-revealable'
  end

  def add_nation_visiblity
    @address.nation? ? 'js-revealable' : ''
  end
end
