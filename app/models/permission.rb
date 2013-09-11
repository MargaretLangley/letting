class Permission < Struct.new(:user)
  def allow?(controller, action)
    # return true if controller == 'sessions'
    # if user
    #   return true if controller == 'blocks'
    #   return true if controller == 'clients'
    #   return true if controller == 'properties'
    # end
    true
  end
end