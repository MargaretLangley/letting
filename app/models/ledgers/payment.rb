####
#
# Payment
#
# When a payment is recieved from a tenant it is represented by the payment
# object on the database.
#
# Payments are a collection of credits which offset against debits.
#
####
#
class Payment < ActiveRecord::Base
  belongs_to :account
  has_many :credits, dependent: :destroy do
    def clear_up
      each(&:clear_up)
    end

    def negate
      each(&:negate)
    end
  end
  before_validation :clear_up

  accepts_nested_attributes_for :credits, allow_destroy: true
  validates :account_id, :on_date, presence: true
  validates :amount, numericality: { other_than: 0,
                                     message: 'should not be zero.' }
  after_initialize do
    self.amount = 0 if amount.blank?
    self.on_date = Date.current if on_date.blank?
  end

  def account_exists?
    account.present?
  end

  def negate
    self.amount *= -1
    credits.negate
    self
  end

  def prepare
    return unless account_exists?
    credits.push(*account.prepare_credits)
  end

  def clear_up
    negate
    credits.clear_up
  end
end
