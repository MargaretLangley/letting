####
#
# AccountsController
#
# Why does this class exist?
#
# Restful actions on the Accounts resource
#
# How does this fit into the larger system?
#
# Accounts are at the heart of the application
#
####
#
class AccountsController < ApplicationController

  def index
    @properties = User.all
  end

end
