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
    "#{property.client.try(:human_ref)}" \
      " #{property.client.try(:entities).try(:full_name)}".strip
  end

  def property_prev
    return '' unless @property.prev

    @property.prev.human_ref
  end

  def property_next
    return '' unless @property.next

    @property.next.human_ref
  end
end
