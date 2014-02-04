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
end