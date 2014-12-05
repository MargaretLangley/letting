######
# UseEditPage
#
# Encapsulates the User Page (edit)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#####
#
class UserEditPage
  include Capybara::DSL

  def visit_index_page
    visit '/users'
    self
  end

  def click_edit
    click_on('Edit')
  end

  def click_update_user
    click_on('Update User')
  end

  def fill_form(nickname, email, password, confirmation = password)
    within_fieldset 'user' do
      fill_in 'Nickname', with: nickname
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: confirmation
    end
  end

  def successful?
    has_content? /created|updated/i
  end

  def errored?
    has_css? '[data-role="errors"]'
  end
end
