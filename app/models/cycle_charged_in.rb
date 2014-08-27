class CycleChargedIn < ActiveRecord::Base
  belongs_to :charge_cycle
  belongs_to :charged_in
end
