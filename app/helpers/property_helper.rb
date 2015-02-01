####
#
# PropertyHelper
#
####
#
module PropertyHelper
  def client_list
    Client.order(:human_ref).map do |client|
      {
        label: "#{client.human_ref} #{client.full_name}",
        value: client.id
      }
    end
  end

  # Create client information from property
  #
  def client_to_s property
    "#{property.client.try(:human_ref)} #{property.client.try(:entities).try(:full_name)}".strip
  end
end
