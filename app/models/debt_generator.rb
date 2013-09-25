class DebtGenerator < ActiveRecord::Base
  has_many :debts
  accepts_nested_attributes_for :debts
end
