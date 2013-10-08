class DebtGeneratorCreatePage
  include Capybara::DSL

  def visit_page
    visit '/debt_generators/new'
    self
  end

  def search_term term
    fill_in 'debt_generator_search_string', with: term
    self
  end

  def search
    click_on 'Search'
  end

  def choose_dates
    click_on 'or choose dates'
  end

  def make_charges
    click_on 'Invoice Charges'
  end

  def have_no_properties?
    has_content? /Properties are not being found./i
  end

  def have_empty_search?
    has_content? /No properties matching 'Garbage'/i
  end

  def created?
    has_content? /Debts successfully created!/i
  end

end
