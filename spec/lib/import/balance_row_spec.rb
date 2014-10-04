require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/balance_row'

####
#
# balance_row_spec.rb
#
# unit testing for debit_row
# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/LineLength
#
####
#
module DB
  describe BalanceRow, :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-24 00:00:00',
            description: 'Balance',
            amount: 5,
            balance_amount: 5
      BalanceRow.new parse_line \
      %(#{human_ref}, #{charge_code}, #{date}, #{description}, #{amount}, 0, #{balance_amount})
    end

    it('human_ref') { expect(row(human_ref: 9).human_ref).to eq 9 }
    it('charge_code') { expect(row(charge_code: 'GR').charge_code).to eq 'GR' }
    it 'on_date' do
      expect(row(date: '2012-03-20 00:00:00').on_date)
        .to eq '2012-03-20 00:00:00'
    end
    it('amount') { expect(row(amount: 5.5).amount).to eq(5.5) }

    it 'rows attributes are returned' do
      charge = charge_new charge_type: 'Insurance'
      property_create human_ref: 9, account: account_new(charge: charge)
      row = row(charge_code: 'Ins', amount: 3.05)
      expect(row.attributes[:charge_id]).to eq charge.id
      expect(row.attributes[:on_date]).to eq Time.parse '2012-03-25 00:00:00'
      expect(row.attributes[:amount]).to eq 3.05
    end

    describe 'methods' do
      describe 'charge_type' do
        context 'balance with description' do
          it 'returns charge_type' do
            spec_row = row charge_code: 'Bal',
                           description: 'Balance Service Charge'
            expect(spec_row.charge_type).to eq 'Service Charge'
          end
        end
        context 'balance with charge code' do
          it 'returns charge_type' do
            spec_row = row(charge_code: 'GR')
            expect(spec_row.charge_type).to eq 'Ground Rent'
          end
        end
      end
      describe '#description_to_charge' do
        it 'returns ' do
          spec_row = row(description: 'Balance Service Charge')
          expect(spec_row.description_to_charge).to eq 'Service Charge'
        end
        it 'returns ' do
          spec_row = row(description: 'Service Charge 2012/13')
          expect(spec_row.description_to_charge).to eq 'Service Charge'
        end
      end

      describe '#next_on_date' do
        it 'finds next on_date' do
          cycle = charge_cycle_new(due_ons: [DueOn.new(month: 4, day: 1)])
          charge = charge_new charge_type: 'Ground Rent',
                              charge_cycle: cycle
          property_create human_ref: 9, account: account_new(charge: charge)

          expect(row.next_on_date).to eq Date.new(2012, 4, 1)
        end

        it 'finds next on_date even if same as due_date' do
          cycle = charge_cycle_new(due_ons: [DueOn.new(month: 3, day: 24)])
          charge = charge_new charge_type: 'Ground Rent',
                              charge_cycle: cycle
          property_create human_ref: 9, account: account_new(charge: charge)

          expect(row.next_on_date).to eq Date.new(2012, 3, 24)
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end
  end
end
