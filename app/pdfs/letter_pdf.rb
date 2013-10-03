# Commented out because in production it is asking for prawn
# Does it need to be added to Gemfile?



# class LetterPdf < Prawn::Document
#   def initialize(property)
#     @property = property
#     super(top_margin: 70)
#     text "#{@property.human_id}"
#     text "#{address_road()}"
#     text "#{@property.address.district}"
#     text "#{@property.address.town}"
#     text "#{@property.address.county}"
#     text "#{@property.address.postcode}"
#    end

# private

# def address_road()
#   if  @property.address.road_no.length > 0
#   address_road = @property.address.road_no + " " + @property.address.road
# else
#   address_road =  @property.address.road
#  end

# end

# end


