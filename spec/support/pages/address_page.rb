class AddressPage
  include Capybara::DSL

  def add_district
    click_on 'Add a district line to the address'
  end

  def delete_district
    click_on 'Delete'
  end

  def district_visible?
    has_css?('.v_district', visible: true)
  end

  def add_nation
    click_on 'Add a nation line to the address'
  end

  def nation_visible?
    has_css?('.v_nation', visible: true)
  end
end
