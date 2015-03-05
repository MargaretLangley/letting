module ProductHelper
  MAX_DISPLAYABLE_PRODUCTS = 8

  def blankers(used_lines:)
    "bottom-#{MAX_DISPLAYABLE_PRODUCTS - used_lines}-line-spacer"
  end
end
