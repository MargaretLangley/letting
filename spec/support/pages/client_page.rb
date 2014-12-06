################################
# Client Page
#
# Encapsulates the Client Page (new and edit)
#
# The layer hides the capybara calls to make the functional rspec tests that
# use this class simpler.
#
# rubocop: disable Metrics/ParameterLists
#
class ClientPage
  include Capybara::DSL

  def new
    visit '/clients/new'
    self
  end

  def edit
    visit '/clients/'
    click_on 'Edit'
    self
  end

  def button action
    click_on "#{action} Client"
  end

  def click(choice)
    click_on choice, exact: true
  end

  def fill_in_client_id(client_id)
    fill_in 'Client ID', with: client_id
  end

  def fill_in_entity(order:, title:, initials:, name:)
    id_stem = "client_entities_attributes_#{order}"
    fill_in "#{id_stem}_title", with: title
    fill_in "#{id_stem}_initials", with: initials
    fill_in "#{id_stem}_name", with: name
  end

  def fill_in_address(flat_no:, house_name:, road_no:, road:,
                      town:, district:, county:, postcode:)
    fill_in 'Flat no', with: flat_no
    fill_in 'House name', with: house_name
    fill_in 'Road no', with: road_no
    fill_in 'Road', with: road
    fill_in 'Town', with: town
    fill_in 'District', with: district
    fill_in 'County', with: county
    fill_in 'Postcode', with: postcode
  end

  def expect_ref(page, client_id)
    page.expect(find_field('Client ID').value).to page.have_text client_id
  end

  def expect_entity(page, order:, title:, initials:, name:)
    id_stem = "client_entities_attributes_#{order}"
    page.expect(find_field("#{id_stem}_title").value).to page.have_text title
    page.expect(find_field("#{id_stem}_initials").value).to \
      page.have_text initials
    page.expect(find_field("#{id_stem}_name").value).to page.have_text name
  end

  def expect_address(page, flat_no:, house_name:, road_no:, road:,
                            town:, district:, county:, postcode:)
    page.expect(find_field('Flat no').value).to page.have_text flat_no
    page.expect(find_field('House name').value).to page.have_text house_name
    page.expect(find_field('Road no').value).to page.have_text road_no
    page.expect(find_field('Road').value).to page.have_text road
    page.expect(find_field('District').value).to page.have_text district
    page.expect(find_field('Town').value).to page.have_text town
    page.expect(find_field('County').value).to page.have_text county
    page.expect(find_field('Postcode').value).to page.have_text postcode
  end

  def successful?
    has_content? /created|updated/i
  end
end
