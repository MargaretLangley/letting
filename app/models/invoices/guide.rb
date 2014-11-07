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
end
