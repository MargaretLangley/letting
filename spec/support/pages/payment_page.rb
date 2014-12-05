######
# PaymentPage
#
# Encapsulates the PaymentPage
#
# The layer hides the Capybara calls to make the functional rspec tests use
# a higher level of abstraction.
# http://robots.thoughtbot.com/acceptance-tests-at-a-single-level-of-abstraction
#
#####
#
class PaymentPage
  include Capybara::DSL

  def visit_new
    visit '/payments/new'
    self
  end

  def visit_edit payment_id
    visit "/payments/#{payment_id}/edit"
    self
  end

  def human_ref property
    fill_in 'search_terms', with: property
    self
  end

  def payment= amount
    fill_in 'payment_credits_attributes_0_amount', with: amount
  end

  def payment
    find_field('payment_credits_attributes_0_amount').value
  end

  def search
    click_on 'Search'
    self
  end

  def pay
    click_on 'submit'
    self
  end

  # has_search?
  # faster to test data-role is missing than negating empty_search?
  # has_no_css - does not wait for timeout to decide
  #              that the role is missing.
  #
  def populated_search?
    has_no_css? '[data-role="unknown-property"]'
  end

  def empty_search?
    has_css? '[data-role="unknown-property"]'
  end

  def receivables?
    has_css? '[data-role="receivables"]'
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def successful?
    has_content? /created|updated/i
  end
end
