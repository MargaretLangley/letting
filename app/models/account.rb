class Account < ActiveRecord::Base
  belongs_to :property

  def payment payment
    account_entries.build.payment payment
  end

  has_many :account_entries

end
