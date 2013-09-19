class Permission < Struct.new(:user)
  def allow?(controller, action)
    return true if controller == 'sessions'
    if user
      return true if controller == 'blocks'
      return true if controller == 'clients'
      return true if controller == 'debts'
      return true if controller == 'properties'
      return true if controller == 'payments'
      if user.admin?
        return true if controller == 'users'
      end
    end
    false
  end
end