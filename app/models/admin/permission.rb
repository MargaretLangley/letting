####
#
# Permission
#
# Authorization of a user accessing the application.
#
# How does it fit in to the larger system
#
# All controllers and some views check to see if the current user has
# permissions to continue with the request.
#
# guest users - not logged in
# users       - standard users - access to everything except admin controllers
#                                this is the users controller
# admin users - admin          - access to users controller - allowed to create
#                                and edit users but otherwise the same as a
#                                user
#
####
#
class Permission < Struct.new(:user)
  def allow?(controller, _action)
    return true if guest_controllers.include?(controller)
    if user
      return true if user_controllers.include?(controller)
      return true if user.admin? && admin_controllers.include?(controller)
    end
    false
  end

  def guest_controllers
    %w(sessions)
  end

  def user_controllers
    %w(accounts
       clients
       debits
       debit_generators
       errors
       invoices
       properties
       payments
       search_suggestions
       sheets)
  end

  def admin_controllers
    %w(users)
  end
end