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
####
#
module NavigationHelper
  def main_menu_active? controller
    if controller_name == controller
      'active-nav'
    else
      'inactive-nav'
    end
  end

  def sub_menu_folded? controller
    if controller_name == controller
      'flatten'
    else
      'folded'
    end
  end
end
