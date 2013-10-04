class Permission < Struct.new(:user)
  def allow?(controller, action)
    return true if guest_controllers.include?(controller)
    if user
      return true if user_controllers.include?(controller)
      return true if user.admin? && admin_controllers.include?(controller)
    end
    false
  end

  def guest_controllers
    %w{sessions}
  end

  def user_controllers
    %w{blocks clients debts debt_generators properties payments}
  end

  def admin_controllers
    %w{users}
  end
end
