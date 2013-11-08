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
    @properties = Property.search(search_param).page(params[:page]).load
  end

  private

    def search_param
      params[:search]
    end

    def property_params
      params.require(:property)
        .permit :human_ref,
                :client_id,
                address_attributes:         address_params,
                entities_attributes:        entities_params,
                billing_profile_attributes: billing_profile_params,
                account_attributes:         account_params
    end

    def billing_profile_params
      %i(id property_id use_profile) + [address_attributes: address_params] +
      [entities_attributes: entities_params]
    end

end
