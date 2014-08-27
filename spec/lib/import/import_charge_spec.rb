require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_charge'

####
#
# import_charge_spec.rb
#
# unit testing for charge_row
#
####
#
module DB
  describe ImportCharge, :import do
    def row
      %q(2002, 2006-12-30 17:17:00, GR, 0, 40.5,  S,) +
      %q(25, 3, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 )
    end

    context 'charge on_date' do
      before :each do
        charged_in_create id: 1, name: 'Arrears'
        charge_cycle_create due_on: DueOn.new(day: 25, month: 3)
        property_create(human_ref: 2002, account: account_new(id: 1))
      end

      it 'One row' do
        expect { import_charge row }.to change(Charge, :count).by 1
      end

      describe 'property filter' do
        it 'allows within range' do
          expect { import_charge row, range: 2002..2002 }
            .to change(Charge, :count).by 1
        end

        it 'filters when out of range' do
          expect { import_charge row, range: 2000..2001 }
            .to change(Charge, :count).by 0
        end
      end

      it 'Not double import' do
        import_charge row
        expect { import_charge row }.to_not change(Charge, :count)
      end

      describe 'multiple imports' do
        def updated_row
          %q(2002, 2006-12-30 17:17:00, GR, 0, 30.5,  S,) +
          %q(25, 3, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 )
        end

        it 'updated changed charge' do
          import_charge row
          import_charge updated_row
          charge = Charge.first
          expect(charge.amount).to eq 30.5 #
        end
      end
    end

    context 'monthly charge' do
      before :each do
        charged_in_create id: 1, name: 'Arrears'
        charge_cycle_create due_on: DueOn.new(day: 8, month: 0)
        property_create(human_ref: 2002, account: account_new(id: 1))
      end

      it 'One monthly row, 12 DueOns' do
        def monthly_row
          %q(2002, 2006-12-30 17:17:00, GR, 0, 40.5,  S,) +
          %q(8, 0, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 )
        end
        expect { import_charge monthly_row }.to change(Charge, :count).by 1
      end
    end

    describe 'errors' do
      context 'no property' do
        it 'fails if property does not exist' do
          expect { import_charge row }
          .to raise_error ActiveRecord::RecordNotFound,
                          'Property human_ref: 2002 - Not found'
        end
      end
    end

    def import_charge row, **args
      ImportCharge.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.charge,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
