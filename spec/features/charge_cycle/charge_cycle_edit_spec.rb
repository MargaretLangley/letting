require 'rails_helper'

describe ChargeCycle, :ledgers, type: :feature do

  before(:each) do
    log_in admin_attributes
    charge_cycle_create id: 3,
                        name: 'Jan/July',
                        order: 11,
                        cycle_type: 'term',
                        due_ons: [DueOn.new(day: 6, month: 10)]
  end

  context '#Edit' do
    it 'basic' do
      visit '/charge_cycles/3/edit'
      expect(page.title). to eq 'Letting - Edit Charge Cycles'
      fill_in 'Name', with: 'April/Nov'
      fill_in 'Order', with: '44'
      due_on(day: 10, month: 2)
      click_on 'Update Charge Cycle'
      expect(page). to have_text /successfully updated!/i
    end

    def due_on(order: 0, day:, month:, year:nil)
      visit '/charge_cycles/3/edit'
      id_stem = "charge_cycle_due_ons_attributes_#{order}"
      fill_in "#{id_stem}_day", with: day
      fill_in "#{id_stem}_month", with: month
      fill_in "#{id_stem}_year", with: year
    end

    it 'uses monthly edit' do
      charge_cycle_create id: 2,
                          name: 'Regular',
                          order: 22,
                          cycle_type: 'monthly',
                          due_ons: [DueOn.new(day: 8, month: 1)]

      visit '/charge_cycles/2/edit'
      expect(page).to have_text 'Monthly'
      fill_in 'Name', with: 'New Monthly'
      fill_in 'Order', with: '21'
      due_on(day: 12, month: 0)
      click_on 'Update Charge Cycle'
      expect(page). to have_text /successfully updated!/i
    end

    it 'goes to index on Cancel' do
      visit '/charge_cycles/3/edit'
      click_on('Cancel')
      expect(page.title). to eq 'Letting - Charge Cycles'
    end

    it 'errors on update' do
      visit '/charge_cycles/3/edit'
      fill_in 'Name', with: ''
      click_on 'Update Charge Cycle'
      expect(page).to have_css '[data-role="errors"]'
    end

  end
end
