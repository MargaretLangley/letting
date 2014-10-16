require 'spec_helper'

################################
# ChargeCyclePage
#
# Encapsulates the ChargeCycle Page (new and edit)
#
# The layer hides the Capybara calls to make the functional rspec tests that
# use this class simpler.
#
class ChargeCyclePage
  include Capybara::DSL
  attr_reader :action, :type

  def initialize type: :term, action: :create
    @type = type
    @action = action
  end

  def enter
    visit "/charge_cycles/new?cycle_type=#{type}" if action == :create
    visit '/charge_cycles/1/edit' if action == :edit
    self
  end

  def name= value
    fill_in 'Name', with: value
    self
  end

  def order= value
    fill_in 'Order', with: value
    self
  end

  def do value
    click_on value
    self
  end

  def due_on order: 0, day:, month:, year: nil
    id_stem = "charge_cycle_due_ons_attributes_#{order}"
    fill_in "#{id_stem}_day", with: day
    if type == :term
      fill_in "#{id_stem}_month", with: month
      fill_in "#{id_stem}_year", with: year
    end
    self
  end

  def association arrears: false, advance: false, mid_term: false
    check 'Arrears' if arrears
    check 'Advance' if advance
    check 'Mid-Term' if mid_term
  end

  def errored?
    has_css? '[data-role="errors"]'
  end

  def success?
    has_content? /successfully/i
  end
end
