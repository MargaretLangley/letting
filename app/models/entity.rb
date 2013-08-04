class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :name, presence: true

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  private
    def ignored_attrs
      ['id', 'entitieable_id', 'entitieable_type', 'created_at', 'updated_at']
    end
end
