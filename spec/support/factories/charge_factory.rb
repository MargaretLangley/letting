# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def charge_new account_id: 2,
               charge_type: 'Ground Rent',
               amount: 88.08,
               dormant: false,
               start_date: '2002-03-25',
               end_date: MAX_DATE,  # app_constants
               charge_cycle: charge_cycle_new,
               charged_in: charged_in_new,
               credits: nil,
               debits: nil

  charge = Charge.new account_id: account_id,
                      charge_type: charge_type,
                      amount: amount,
                      dormant: dormant,
                      start_date: start_date,
                      end_date: end_date,
                      charge_cycle: charge_cycle,
                      charged_in: charged_in
  charge.charge_cycle = charge_cycle if charge_cycle
  charge.charged_in = charged_in if charged_in
  charge.credits = credits if credits
  charge.debits = debits if debits
  charge
end

def charge_create account_id: 2,
                  charge_type: 'Ground Rent',
                  amount: 88.08,
                  dormant: false,
                  start_date: '2002-03-25',
                  end_date: MAX_DATE,  # app_constants
                  charge_cycle: charge_cycle_create,
                  charged_in: charged_in_create,
                  credits: nil,
                  debits: nil

  charge = charge_new account_id: account_id,
                      charge_type: charge_type,
                      amount: amount,
                      dormant: dormant,
                      start_date: start_date,
                      end_date: end_date,
                      charge_cycle: charge_cycle,
                      charged_in: charged_in,
                      credits: credits,
                      debits: debits
  charge.save!
  charge
end
