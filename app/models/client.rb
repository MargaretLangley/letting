class Client < ActiveRecord::Base
  has_many :properties, dependent: :destroy
  include Contact
  before_validation :clear_up_after_form

  validates :human_client_id, numericality: true
  validates :human_client_id, uniqueness: true
  validates :entities, presence: true

  def prepare_for_form
    prepare_contact
  end

  def clear_up_after_form
    entities_for_destruction :empty?
  end

end
