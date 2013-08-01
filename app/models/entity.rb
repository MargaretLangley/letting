class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :name, presence: true

  def empty?
    ignored_attrs = 'id', 'entitieable_id', 'entitieable_type', 'created_at', 'updated_at'
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

end
