####
#
# LiteralSearch
#
# Responsible for exact match seraches for the application.
#
# Used by search Controller
#
####
#
class LiteralSearch
  def self.go query
    Property.find_by(human_ref: query) ||
      Client.find_by(human_ref: query) ||
      User.find_by(nickname: query) ||
      ChargeCycle.find_by(name: query)
  end
end
