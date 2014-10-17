# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/MethodLength

def charge_new id: nil,
               account_id: 2,
               charge_type: 'Ground Rent',
               amount: 88.08,
               dormant: false,
               start_date: '2002-03-25',
               end_date: MAX_DATE,  # app_constants
               cycle: cycle_new,
               charged_in: charged_in_create,
               credits: nil,
               debits: nil

  charge = Charge.new id: id,
                      account_id: account_id,
                      charge_type: charge_type,
                      amount: amount,
                      dormant: dormant,
                      start_date: start_date,
                      end_date: end_date,
                      cycle: cycle,
                      charged_in: charged_in
  charge.cycle = cycle if cycle
  charge.charged_in = charged_in if charged_in
  charge.credits = credits if credits
  charge.debits = debits if debits
  charge
end

def charge_find_or_create id: nil,
                          account_id: 2,
                          charge_type: 'Ground Rent',
                          amount: 88.08,
                          dormant: false,
                          start_date: '2002-03-25',
                          end_date: MAX_DATE,  # app_constants
                          cycle: cycle_new,
                          charged_in: charged_in_create,
                          credits: nil,
                          debits: nil
  Charge.find_by(id: id) || charge_create(id: id,
                                          account_id: account_id,
                                          charge_type: charge_type,
                                          amount: amount,
                                          dormant: dormant,
                                          start_date: start_date,
                                          end_date: end_date,
                                          cycle: cycle,
                                          charged_in: charged_in,
                                          credits: credits,
                                          debits: debits)
end

def charge_create id: id,
                  account_id: 2,
                  charge_type: 'Ground Rent',
                  amount: 88.08,
                  dormant: false,
                  start_date: '2002-03-25',
                  end_date: MAX_DATE,  # app_constants
                  cycle: cycle_create,
                  charged_in: charged_in_create,
                  credits: nil,
                  debits: nil

  charge = charge_new id: id,
                      account_id: account_id,
                      charge_type: charge_type,
                      amount: amount,
                      dormant: dormant,
                      start_date: start_date,
                      end_date: end_date,
                      cycle: cycle,
                      charged_in: charged_in,
                      credits: credits,
                      debits: debits
  charge.save!
  charge
end
