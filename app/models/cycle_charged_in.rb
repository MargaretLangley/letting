####
#
# CycleChargedIn
#
# Join table to allow relationship between charge_cycle and charged_in
#
class CycleChargedIn < ActiveRecord::Base
  belongs_to :charge_cycle
  belongs_to :charged_in
end
