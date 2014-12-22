####
#
# ClientHelper
#
# Shared helper methods
#
# Add methods to client decorator if it is created.
#
####
#
module ClientHelper
  def client_list
    Client.includes(:entities).order(:human_ref).map do |client|
      {
        label: "#{client.human_ref} #{client.full_name}",
        value: client.id
      }
    end
  end
end
