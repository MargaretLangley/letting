class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :road_no, presence: true, unless: :house_name?
  validates :house_name, presence: true, unless: :road_no?

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
