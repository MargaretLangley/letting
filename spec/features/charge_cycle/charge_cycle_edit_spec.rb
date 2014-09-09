require 'rails_helper'

describe ChargeCycle, type: :feature do

  before(:each) do
    log_in
    charge_cycle_create id: 3,
                        name: 'Jan/July',
                        order: 11,
                        period_type: 'term',
                        due_ons: [DueOn.new(day: 6, month: 10)]
    visit '/charge_cycles/3/edit'
  end

  context '#Edit' do
    it 'basic' do
      expect(page.title). to eq 'Letting - Edit Charge Cycles'
      fill_in 'Name', with: 'April/Nov'
      fill_in 'Order', with: '44'
      due_on(day: 10, month: 2)
      click_on 'Update Charge cycle'
      expect(page). to have_text /successfully updated!/i
    end

    def due_on(order: 0, day:, month:, year:nil)
      id_stem = "charge_cycle_due_ons_attributes_#{order}"
      fill_in "#{id_stem}_day", with: day
      fill_in "#{id_stem}_month", with: month
      fill_in "#{id_stem}_year", with: year
    end

    it 'has goes to index on Cancel' do
      click_on('Cancel')
      expect(page.title). to eq 'Letting - Charge Cycles'
    end
  end
end
