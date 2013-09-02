class Client < ActiveRecord::Base
  has_many :properties, dependent: :destroy
  include Contact
  before_validation :clear_up_after_form

  validates :human_id, numericality: true
  validates :human_id, uniqueness: true
  validates :entities, presence: true

  def prepare_for_form
    prepare_contact
  end

  def clear_up_after_form
    entities.clean_up_form
  end

  def self.search search
    if search.blank?
       Client.all.includes(:address).order('human_id ASC')
    else
      self.search_by_all(search)
    end
  end

  private
    def self.search_by_all(search)
      Client.includes(:address, :entities).
      where('human_id = ? OR ' + \
              'entities.name ILIKE ? OR ' + \
              'addresses.house_name ILIKE ? OR ' + \
              'addresses.road ILIKE ? OR '  \
              'addresses.town ILIKE ?',  \
              "#{search.to_i}", "#{search}%", "#{search}%", "#{search}%", "#{search}%" \
              ).references(:address, :entity).order('human_id ASC')
    end
end
