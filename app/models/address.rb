class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, length: { maximum: 10 }, allow_blank: true
  validates :house_name, length: { maximum: 64 }, allow_blank: true
  validates :road_no, length: { maximum: 10 }, allow_blank: true
  validates :road, length: { maximum: 64 }
  validates :district, :town, length: { minimum: 4, maximum: 64 }, allow_blank: true
  validates :county, length: { minimum: 4, maximum: 64 }
  validates :postcode, length: { minimum: 6, maximum: 8 }, allow_blank: true

  scope :search_by_all, ->(search) {
    where( 'addresses.house_name ILIKE ? OR ' + \
              'addresses.road ILIKE ? OR '  \
              'addresses.town ILIKE ?',  \
              "#{search}%", "#{search}%", "#{search}%" \
    )}

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  def copy_approved_attributes
    attributes.except(*ignored_attrs)
  end

  private
    def ignored_attrs
      ['id', 'addressable_id', 'addressable_type', 'created_at', 'updated_at']
    end
end
