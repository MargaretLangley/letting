class Notice < ActiveRecord::Base
  belongs_to :sheet
  validates :instruction, presence: true, allow_blank: true
  validates :clause, presence: true, allow_blank: true
  validates :proxy, presence: true, allow_blank: true
end
