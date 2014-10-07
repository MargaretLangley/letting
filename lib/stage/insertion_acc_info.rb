require_relative 'insertion'
####
#
# Insertion
#
# adding data which are missing. It applies them into the correct position.
#
# Insertion is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
####
#
# extraction
class InsertionAccInfo < Insertion
  def sort originals
    originals.sort_by! { |item| [item[:human_ref].to_i, item[:charge_type]] }
  end
end
