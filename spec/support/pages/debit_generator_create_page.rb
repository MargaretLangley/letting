class DebitGeneratorCreatePage
  include Capybara::DSL

  def visit_page
    visit '/debit_generators/new'
    self
  end

  def search_term term
    fill_in 'debit_generator_search_string', with: term
    self
  end

  def search
    within_fieldset 'debit_generator' do
      click_on 'Search'
    end
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

  def created?
    has_content? /Debits successfully created!/i
  end
end
