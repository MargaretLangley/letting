require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_charge'

module DB

  describe ImportCharge, :import do

    def row
      %q[2002, 2006-12-30 17:17:00, GR, 0, 40.5,  S,] +
      %q[24, 6, 25, 12,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 ]
    end

    context 'success' do
      before :each do
        property_create!
      end

      it 'One row' do
        expect { import_charge row }.to change(Charge, :count).by 1
      end

      it 'One row, 2 DueOns' do
        expect { import_charge row }.to change(DueOn, :count).by 2
      end

      it 'One monthly row, 12 DueOns' do
        def monthly_row
          %q[2002, 2006-12-30 17:17:00, GR, 0, 40.5,  S,] +
          %q[1, 0, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 ]
        end
        expect { import_charge monthly_row }.to change(DueOn, :count).by 12
      end

      context 'filter' do
        it 'allows within range' do
          expect { import_charge row, range: 2002..2002 }.to \
            change(Charge, :count).by 1
        end

        it 'filters if out of range' do
          expect { import_charge row, range: 2000..2001 }.to \
            change(Charge, :count).by 0
        end
      end

      it 'Not double import' do
        import_charge row
        expect { import_charge row }.to_not change(Charge, :count)
      end

      context 'multiple imports' do

        def updated_row
          %q[2002, 2006-12-30 17:17:00, GR, 0, 30.5,  S,] +
          %q[24, 6, 26, 12,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 ]
        end

        it 'updated changed charge' do
          import_charge row
          import_charge updated_row
          charge = Charge.first
          expect(charge.amount).to eq 30.5 #
          expect(charge.due_ons[0].day).to eq 24 # same
          expect(charge.due_ons[1].day).to eq 26 # imp one!
        end
      end
    end

    context 'errors' do
      it 'fails if property does not exist' do
        expect { import_charge row }
        .to raise_error ActiveRecord::RecordNotFound,
        'Property human_ref: 2002 - Not found'
      end
    end

    def import_charge row, args = {}
      ImportCharge.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                 { headers: FileHeader.charge,
                   header_converters: :symbol,
                   converters: lambda { |f| f ? f.strip : nil } }
               )
    end
  end
end
