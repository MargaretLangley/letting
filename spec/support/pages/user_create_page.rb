class UserCreatePage
  include Capybara::DSL
  def visit_new_page
    visit '/users/new'
    self
  end

  def click_create_user
    click_on('Create User')
  end

  def login(email, password, confirmation = password)
    within_fieldset 'user' do
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: confirmation
    end
  end
end
