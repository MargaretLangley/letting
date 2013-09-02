class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :entity_type, presence: true
  validates :name, length: { maximum: 64 }, presence: true
  validates :title, :initials, length: { maximum:10 }

  def prepare
    self.entity_type = 'Person' if new_record?
  end

  def all?
    true
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  def company?
    self.entity_type == 'Company'
  end

  private
    def ignored_attrs
      ['id', 'entitieable_id', 'entitieable_type', 'created_at', 'entity_type', 'updated_at']
    end
end
