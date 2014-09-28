###
#
# Notice
#
# Notice deals with the instructions given on
# an invoice page. Part of template and property
# information. Used when editing instructions
#
####
#
class Notice < ActiveRecord::Base
  MAX_CHAR = 100
  MAX_PROX = 25
  belongs_to :template
  validates :instruction, presence: true,
                          length: { maximum: MAX_CHAR },
                          allow_blank: true
  validates :fill_in, presence: true, allow_blank: true,
             length: { maximum: MAX_CHAR },
             allow_blank: true
  validates :sample, presence: true, allow_blank: true,
             length: { maximum: MAX_PROX },
             allow_blank: true
end
