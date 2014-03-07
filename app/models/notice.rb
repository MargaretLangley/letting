class Notice < ActiveRecord::Base

  validates :notice_head, presence: true, allow_blank: true
  validates :notice_body, presence: true, allow_blank: true
  validates :notice_type, presence: true, allow_blank: true, length: { maximum: 10 }
end
