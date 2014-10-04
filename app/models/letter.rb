####
#
# Letter
#
# Letter is the association between Invoice and Template
#
####
#
class Letter < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :template
  validates :invoice, :template, presence: true
end
