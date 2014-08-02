module PropertiesHelper
  def hide_new_record_unless_first record, index
    record.new_record? && index > 0 ? 'js-revealable' : ''
  end
end
