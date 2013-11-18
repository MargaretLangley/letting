class PaymentCreatePage
  include Capybara::DSL

  def visit_new_page
    visit '/payments/new'
    self
  end

  def human_ref property
    fill_in 'payment_human_ref', with: property
    self
  end

  def payment amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def search
    click_on 'Search'
    self
  end

  def click_create_payment
    click_on 'pay total'
    self
  end

  def on_page?
    current_path == '/payments/new'
  end

  def empty_search?
    has_css? '[data-role="unknown-property"]'
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def has_credits_with_debits?
    has_css? '[data-role="credits-with-debits"]'
  end

  def successful?
    has_content? /successfully created/i
  end
end
