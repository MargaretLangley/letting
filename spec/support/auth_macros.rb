module AuthMacros

  def log_in attributes = {}
    current_user = User.create! user_attributes attributes
    visit '/login/'
    within_fieldset 'login' do
      fill_in 'Email',    with: current_user.email
      fill_in 'Password', with: current_user.password
      click_on 'Log In'
    end
    expect(page).to have_content 'Logged in'
  end
end
