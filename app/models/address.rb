class Address < ActiveRecord::Base
  belongs_to :contact, polymorphic: true
  validates :contact_id, presence: true
end
