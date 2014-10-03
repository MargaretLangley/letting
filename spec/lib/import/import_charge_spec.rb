require 'csv'
require 'rails_helper'
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
    before :each do
      charged_in_create id: 1, name: 'Arrears'
      property_create human_ref: 2000, account: account_new
    end

    def row human_ref: 2000, charged_in: 0, month: 3, day: 25, amount: 5
      %(#{human_ref}, 2006-12-30 17:17:00, GR, #{charged_in}, #{amount},  S,) +
      %(#{day}, #{month}, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 )
    end

    context 'charge with on_date cycle' do
      before { charge_cycle_create due_ons: [DueOn.new(day: 25, month: 3)] }

      it 'imports a single row' do
        expect { import_charge row }.to change(Charge, :count).by 1
      end

      describe 'property filter' do
        it 'allows within given range' do
          expect { import_charge row(human_ref: 2000), range: 2000..2000 }
            .to change(Charge, :count).by 1
        end

        it 'filters when outside range' do
          expect { import_charge row(human_ref: 2000), range: 1990..1999 }
            .to change(Charge, :count).by 0
        end

        it 'filters when charge amount 0' do
          expect { import_charge row amount: 0 }.to change(Charge, :count).by 0
        end

        it 'warns about filtering a charge with 0 amount.' do
          expect { warn 'Filtering charge with amount 0' }.to output.to_stderr
          import_charge row human_ref: 2000, amount: 0
        end
      end

      it 'does not double import' do
        import_charge row human_ref: 2000
        expect { import_charge row human_ref: 2000 }
          .to_not change(Charge, :count)
      end

      it 'can update charge' do
        import_charge row(amount: 25.00)
        import_charge row(amount: 30.05)
        expect(Charge.first.amount).to eq 30.05
      end
    end

    context 'charge with monthly cycle' do
      before { charge_cycle_create due_ons: [DueOn.new(day: 8, month: 0)] }

      it 'imports a monthly row' do
        expect { import_charge row day: 8, month: 0 }
          .to change(Charge, :count).by 1
      end
    end

    describe 'errors with no property' do
      it 'fails if property does not exist' do
        expect { warn 'Property human_ref: 2002 - Not found' }
          .to output.to_stderr
        import_charge row human_ref: 2002
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
