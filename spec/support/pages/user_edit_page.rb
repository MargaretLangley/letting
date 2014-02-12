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
end
