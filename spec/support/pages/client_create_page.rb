class ClientCreatePage
  include Capybara::DSL

  def visit_new_page
    visit '/clients/new'
    self
  end

  def click_create_client
    click_on 'Create Client'
  end

  def click(choice)
    click_on choice
  end

  def fill_in_form(client_id)
    fill_in 'Client ID', with: client_id

    within_fieldset 'client_entity_0' do
      fill_in 'Title',    with: 'Mr'
      fill_in 'Initials', with: 'W G'
      fill_in 'Name',     with: 'Grace'
    end

    within_fieldset 'client_address' do
      fill_in_address_nottingham
    end
  end

end
