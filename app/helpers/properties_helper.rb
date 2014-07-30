module PropertiesHelper
  def hide_new_record_unless_first record, index
    record.new_record? && index > 0 ? 'js-revealable' : ''
  end

  def hide_if_first_record index
    'js-revealable' if index == 0
  end

  def destroyable record, index
    record.persisted? && index > 0 ? 'destroyable' : ''
  end
end
