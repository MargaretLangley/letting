# rubocop: disable Style/ParameterLists
# rubocop: disable Style/MethodLength

def charge_new account_id: 2,
               charge_type: 'Ground Rent',
               amount: 88.08,
               dormant: false,
               start_date: '2011-03-25',
               end_date: MAX_DATE,  # app_constants
               charge_cycle: charge_cycle_new,
               charged_in: charged_in_new

  base_charge account_id: account_id,
              charge_type: charge_type,
              amount: amount,
              dormant: dormant,
              start_date: start_date,
              end_date: end_date,
              charge_cycle: charge_cycle,
              charged_in: charged_in
end

def charge_create account_id: 2,
                  charge_type: 'Ground Rent',
                  amount: 88.08,
                  dormant: false,
                  start_date: '2011-03-25',
                  end_date: MAX_DATE,  # app_constants
                  charge_cycle: charge_cycle_create,
                  charged_in: charged_in_create

  charge = base_charge account_id: account_id,
                       charge_type: charge_type,
                       amount: amount,
                       dormant: dormant,
                       start_date: start_date,
                       end_date: end_date,
                       charge_cycle: charge_cycle,
                       charged_in: charged_in
  charge.save!
  charge
end

def base_charge(account_id:,
                charge_type:,
                amount:,
                dormant:,
                start_date:,
                end_date:,
                charge_cycle:,
                charged_in:)
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
  charge
end
