module NavigationHelper
  def active_nav? controller
    if controller_name == controller
      'active-nav'
    else
      'inactive-nav'
    end
  end

  def menu_folded? controller
    if controller_name == controller
      'flatten'
    else
      'folded'
    end
  end
end
