class HouseAddress < Address
  validates :road_no, presence: true, unless: :house_name?
  validates :house_name, presence: true, unless: :road_no?
end
