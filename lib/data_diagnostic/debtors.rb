class Debtors
  attr_reader :account
  attr_reader :human_ref_range
  attr_accessor :count

  def self.go human_ref_range
    new(human_ref_range).calculate
  end

  def initialize human_ref_range
    @human_ref_range = human_ref_range
    @count = 0
  end

  def calculate
    Account.all.each do |account|
      @account = account
      balance_status if allowed?
    end
  end

  def balance_status
    return if debit_amount == credit_amount
    # &&
    # account.charges.size > 1 &&
    # account.debits.select(:charge_id).uniq.size > 1 &&
    # account.credits.size > 0
    # If I put these commented out statements in
    # you
    @count += 1
    # Import is not a rails app and should not go to logger
    # rubocop: disable Rails/Output
    puts no_balance_msg
  end

  def allowed?
    return true if @range.nil?
    !filtered?
  end

  def filtered?
    human_ref_range.exclude? account.property.human_ref
  end

  def debit_amount
    account.debits.where(on_date: date_range).to_a.sum(&:amount)
  end

  def credit_amount
    account.credits.where(on_date: date_range).to_a.sum(&:amount)
  end

  def date_range
    before_first_db_date..(last_account_credit || Date.current.end_of_year)
  end

  def last_account_credit
    account.credits.order('on_date desc').try(:first).try(:on_date)
  end

  def before_first_db_date
    Date.new(2000, 1, 1)
  end

  def no_balance_msg
    "#{@count} Property #{account.property.human_ref} Balance: #{debit_amount - credit_amount}"
  end
end
