######
# UserCreatePage
#
# Encapsulates the PaymentNewPage - despite the name (new/create)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#####
#
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

  def payment= amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def payment
    find_field('payment_credits_attributes_0_amount').value
  end

  def search
    within_fieldset 'payment' do
      click_on 'Search'
    end
    self
  end

  def click_create_payment
    click_on 'Pay Total'
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

  def receivables?
    has_css? '[data-role="receivables"]'
  end

  def successful?
    has_content? /successfully created/i
  end
end
