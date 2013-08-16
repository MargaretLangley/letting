class Block < ActiveRecord::Base
 validates :name, length: { maximum: 64 }, presence: true
end
