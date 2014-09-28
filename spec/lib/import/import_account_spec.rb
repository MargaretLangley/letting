require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_account'
# rubocop: disable Style/Documentation

module DB
  describe ImportAccount, :import do

    describe 'debit with payment' do
      def debit_with_payment
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 47.5,    0, 47.5
           8, GR, 2012-01-11 15:32:00, Payment Gr....,    0, 47.5,    0)
      end

      it 'parsed' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        expect { ImportAccount.import parse debit_with_payment }
          .to change(Payment, :count).by 1
      end
    end

    describe 'two debits with 1 payment' do
      def two_debits_1_payment
        # Debit (2011-12-25), Debit (2012-12-25), Payment (2012-01-11)
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           8, GR, 2012-12-25 00:00:00, Ground Rent..., 40.5,    0, 81.0
           8, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 40.5, 40.5)
      end

      it 'parsed' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        expect do
          ImportAccount.import parse two_debits_1_payment
        end.to change(Credit, :count).by 1
        expect(Debit.all.size).to eq(2)
      end
    end

    describe 'payment covering 2 debits' do

      def payment_covering_2_debits
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           8, GR, 2012-12-25 00:00:00, Ground Rent..., 40.5,    0, 81.0
           8, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 81.0,    0)
      end

      it 'parses' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        expect { ImportAccount.import parse payment_covering_2_debits }
          .to change(Credit, :count).by 1
        expect(Debit.all.size).to eq(2)
      end
    end

    describe 'filter' do

      def single_row
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 47.5,    0, 47.5)
      end

      it 'allows within range' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        expect { import_account single_row, range: 8..8 }
          .to change(Debit, :count).by 1
      end

      it 'filters if out of range' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        expect { import_account single_row, range: 2..7 }
          .to change(Debit, :count).by 0
      end
    end

    describe 'two properties' do
      def two_properties
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           8, GR, 2012-01-11 15:32:00, Payment Grou..,    0, 40.5, 40.5
           9, GR, 2011-12-25 00:00:00, Ground Rent .., 30.5,    0, 30.5
           9, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 30.5, 30.5)
      end

      it 'parses' do
        cycle = charge_cycle_new due_ons: [DueOn.new(day: 25, month: 12)]
        create_charged_property human_ref: 8, cycle: cycle
        create_charged_property human_ref: 9, cycle: cycle

        expect { import_account two_properties }.to change(Credit, :count).by 2
        expect(Debit.all.size).to eq(2)
        expect(Property.find_by!(human_ref: 8).account.credits.size).to eq(1)
        expect(Property.find_by!(human_ref: 9).account.credits.size).to eq(1)
      end
    end

    describe 'unknown row' do
      def unknown_row
        %q(8, XX, 2011-08-01 00:00:00, ,                  0,    0,    0)
      end
      it 'error if row type unknown' do
        property_create(human_ref: 8,
                        account: account_new(charge: charge_new))
        expect { import_account unknown_row }
          .to raise_error AccountRowTypeUnknown, \
                          'Unknown Row Property:8, charge_code: XX'
      end
    end

    describe 'balance' do
      def balance_empty
        %q(8, Bal, 2011-12-25 00:00:00, ,                  0,    0,    0)
      end
      it 'ignores empty balance' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        import_account balance_empty
        expect(Charge.all.size).to eq(1)
        expect(Credit.all.size).to eq(0)
        expect(Debit.all.size).to eq(0)
        expect(Payment.all.size).to eq(0)
      end

      def balance_non_zero
        %q(8, Bal, 2011-1-01 00:00:00, ,    20,    0,    20)
      end

      it 'imports non-zero balance' do
        charged_in = charged_in_create name: 'Arrears'
        cycle = charge_cycle_create name: 'Yearly - Jan 1st',
                                    due_ons: [DueOn.new(day: 1, month: 1)]
        charge = charge_new charge_cycle: cycle, charged_in: charged_in
        property_create human_ref: 8,
                        account: account_new(charge: charge)

        expect { ImportAccount.import parse balance_non_zero }
          .to change(Charge, :count).by 1
        expect(Debit.all.size).to eq(1)
      end

      it 'invalidates balance without a charge cycle named Yearly' do
        charged_in = charged_in_create name: 'Arrears'
        cycle = charge_cycle_create name: 'Another Name',
                                    due_ons: [DueOn.new(day: 1, month: 1)]
        charge = charge_new charge_cycle: cycle, charged_in: charged_in
        property_create human_ref: 8,
                        account: account_new(charge: charge)

        expect { ImportAccount.import parse balance_non_zero }
          .to raise_error ActiveRecord::RecordInvalid
      end

      it 'invalidates balance without charged_in named arrears' do
        cycle = charge_cycle_create name: 'Yearly - Jan 1st',
                                    due_ons: [DueOn.new(day: 1, month: 1)]
        charge = charge_new charge_cycle: cycle
        property_create human_ref: 8,
                        account: account_new(charge: charge)

        expect { ImportAccount.import parse balance_non_zero }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    describe 'advance payments' do
      def advance_payment
        %q(8, GR, 2012-12-01 10:22:00, Payment Gro...,    0,   20,  -20
           8, GR, 2012-12-25 00:00:00, Ground Rent...,   20,    0,    0)
      end

      it 'parses' do
        create_charged_property human_ref: 8,
                                cycle: new_charge_cycle(month: 12, day: 25)
        ImportAccount.import parse advance_payment
        expect(Credit.all.size).to eq(1)
        expect(Debit.all.size).to eq(1)
        expect(Payment.all.size).to eq(1)
      end
    end

    def create_charged_property human_ref: 8, cycle: new_charge_cycle
      property_create \
        human_ref: human_ref,
        account: account_new(charge: charge_new(charge_cycle: cycle))
    end

    def new_charge_cycle(day:, month:)
      charge_cycle_new due_ons: [DueOn.new(day: 25, month: 12)]
    end

    def import_account row, **args
      ImportAccount.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end

  end
end
