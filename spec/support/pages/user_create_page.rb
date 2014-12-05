######
# UserCreatePage
#
# Encapsulates the User Page (new)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#####
#
class UserCreatePage
  include Capybara::DSL
  def enter
    visit '/users/new'
    self
  end

  def click
    click_on('Create User')
  end

  def fill_form(nickname, email, password, confirmation = password)
    within_fieldset 'user' do
      fill_in 'Nickname', with: nickname
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: confirmation
    end
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def successful?
    has_content? /created|updated/i
  end
end
