class ClientUpdatePage
  include Capybara::DSL

  def click_update_client
    click_on 'Update Client'
  end

  def click_view
    click_on 'View'
  end

  def click(choice)
    click_on choice
  end

  def fill_in_2nd_ent_form
    within_fieldset 'client_entity_1' do
      fill_in 'Title',    with: 'Mr'
      fill_in 'Initials', with: 'I'
      fill_in 'Name',     with: 'Test'
    end
  end

  def fill_in_cancel_form
    within_fieldset 'client_entity_0' do
      fill_in 'Title',    with: 'Mr'
      fill_in 'Name',     with: 'Whistleblower'
    end
    click_on 'Cancel'
  end

end
