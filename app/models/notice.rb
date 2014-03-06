class Notice < ActiveRecord::Base

  validates :minor, presence: true, allow_blank: true
  validates :major, presence: true, allow_blank: true
  validates :minor_type, presence: true, allow_blank: true, length: { maximum: 10 }
  validates :major_type, presence: true, allow_blank: true, length: { maximum: 10 }
end
