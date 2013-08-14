class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :town, :road, :type, presence: true

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  def self.types
    { 'Flat' => 'FlatAddress', 'House' => 'HouseAddress'}
  end

  def copy_approved_attributes
    attributes.except(*ignored_attrs)
  end

  private
    def ignored_attrs
      ['id', 'addressable_id', 'addressable_type', 'created_at', 'updated_at']
    end
end
