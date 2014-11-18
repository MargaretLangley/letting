###
#
# Guide
#
# Guide deals with the instructions given on
# an invoice page. Part of template and property
# information. Used when editing instructions
#
####
#
class Guide < ActiveRecord::Base
  MAX_CHAR = 100
  MAX_PROX = 25
  belongs_to :template
  validates :instruction, presence: true,
                          length: { maximum: MAX_CHAR }
  validates :fillin, presence: true,
                     length: { maximum: MAX_CHAR }
  validates :sample, presence: true,
                     length: { maximum: MAX_PROX }
end
