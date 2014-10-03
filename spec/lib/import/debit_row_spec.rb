require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/debit_row'

####
#
# debit_row_spec.rb
#
# unit testing for debit_row
#
####
#
module DB
  describe DebitRow, :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-25 00:00:00',
            amount: 50.5
      DebitRow.new parse_line \
      %(#{human_ref}, #{charge_code}, #{date}, Insurance, #{amount}, 0, 0)
    end

    it('human_ref') { expect(row(human_ref: 9).human_ref).to eq 9 }
    it('charge_code') { expect(row(charge_code: 'GR').charge_code).to eq 'GR' }
    it 'on_date' do
      expect(row(date: '2012-03-20 00:00:00').on_date)
        .to eq '2012-03-20 03:00:00'
    end
    it('amount') { expect(row(amount: 5.5).amount).to eq(5.5) }

    context 'negative credit' do
      def debit_negative_credit amount: -1.5
        %(2002, GR, 2012-03-25 00:00:00, Ground Rent, 0, #{amount}, 0)
      end
      it 'calculates amount from negative credit' do
        row = DebitRow.new parse_line debit_negative_credit
        expect(row.amount).to eq 1.5
      end
    end

    it 'rows attributes are returned' do
      charge = charge_new charge_type: 'Insurance'
      property_create human_ref: 9, account: account_new(charge: charge)
      row = row(charge_code: 'Ins', amount: 3.05)
      expect(row.attributes[:charge_id]).to eq charge.id
      expect(row.attributes[:on_date]).to eq '2012-03-25 03:00:00'
      expect(row.attributes[:amount]).to eq 3.05
    end

    describe '#period' do
      it 'returns when available' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 20, month: 3)]
        charge = charge_new charge_cycle: cycle
        property_create human_ref: 9, account: account_new(charge: charge)
        expect(row(date: Date.new(2012, 3, 20)).period)
          .to eq Date.new(2012, 3, 20)..Date.new(2013, 3, 19)
      end

      it 'returns invalid when period unmatched.' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 20, month: 3)]
        charge = charge_new charge_cycle: cycle
        property_create human_ref: 9, account: account_new(charge: charge)
        expect { row(date: Date.new(2012, 12, 12)).period }
          .to raise_error PeriodUnknown
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
