class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  def empty?
    ignored_attrs =  'id', 'addressable_id', 'addressable_type', 'created_at', 'updated_at'
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end
end
