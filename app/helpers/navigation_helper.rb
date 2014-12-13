####
#
# Navigation
#
# Uses styles to display the menu according to state.
# Main Menu - is the first level navigation
# Sub-Menu - is the second level navigation
#
# active-nav, inactive-nav - are different styles
#
# folded - alias css hidden
# flatten - for understanding only - it has no CSS styling.
#
# controller_name is a constant, converted from the class name
#
####
#
module NavigationHelper
  def main_menu_active? controller
    if controller.include? controller_name
      'active-nav'     # darker colour
    else
      'inactive-nav'   # lighter colour
    end
  end

  def sub_menu_state controller
    if controller.include? controller_name
      'flatten'   # no css
    else
      'folded'    # hidden
    end
  end
end
