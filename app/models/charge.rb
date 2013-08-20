class Charge < ActiveRecord::Base
  belongs_to :property
  has_many :due_on, dependent: :destroy
  validates :amount, :charge_type, :due_in, presence: true

  def empty?
    attributes.except(*ignored_attrs).values.all?( &:blank? )
  end

  private
    def ignored_attrs
      ['id','property_id', 'created_at', 'updated_at']
    end
end
