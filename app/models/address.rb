class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  validates :county, :road, presence: true
  validates :flat_no, length: { maximum: 10 }, allow_blank: true
  validates :house_name, presence: true, unless: :road_no?
  validates :house_name, length: { maximum: 64 }, allow_blank: true
  validates :road_no, presence: true, unless: :house_name?
  validates :road_no, length: { maximum: 10 }, allow_blank: true
  validates :road, length: { maximum: 64 }
  validates :district, :town, length: { minimum: 4, maximum: 64 }, allow_blank: true
  validates :county, length: { minimum: 4, maximum: 64 }
  validates :postcode, length: { minimum: 6, maximum: 8 }
  #validates :postcode, if :postcode.include ''?

  #validates_format_of :postcode, :with =>  /^([A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKS-UW])\s?[0-9][ABD-HJLNP-UW-Z]{2}|(GIR\ 0AA)|(SAN\ TA1)|(BFPO\ (C\/O\ )?[0-9]{1,4})|((ASCN|BBND|[BFS]IQQ|PCRN|STHL|TDCU|TKCA)\ 1ZZ))$$/i, :message => "invalid postcode"

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
