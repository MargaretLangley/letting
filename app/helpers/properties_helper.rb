module PropertiesHelper
  def left_pad_int_with_upto_2_zeros number
    sprintf "%02i", number
  end

  def hide_new_record_unless_first record, index
    "display: none;" if record.new_record? && index > 0
  end

end
