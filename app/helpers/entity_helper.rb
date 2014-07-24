module EntityHelper
  def first_record? index
    return false if index > 0
    true
  end

  # First record
  # DONOTLIKE
  #
  def hide_or_destroy record
    record.new_record? ? 'js-hide-link' : 'js-destroy-link'
  end
end
