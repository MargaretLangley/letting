module NavigationHelper
  def active_nav? controller
    if controller_name == controller
      'active-nav'
    else
      'inactive-nav'
    end
  end

  def revealable? controller
    if controller_name == controller
      'visible'
    else
      'revealable'
    end
  end
end
