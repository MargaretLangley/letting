require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_account'

module DB

  describe ImportAccount, :import do
    let!(:property) do
      property_with_charge_create! human_ref: 122
    end

    context 'one debit' do
      def one_debit_csv
        %q[122, GR, 2011-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5]
      end

      it 'parsed' do
        expect { ImportAccount.import parse one_debit_csv }.to \
          change(Debit, :count).by 1
      end
    end

    context 'two debits' do
      def two_debit_csv
        %q[122, GR, 2011-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5
           122, GR, 2012-12-25 12:00:00, Ground Rent..., 37.5,    0, 37.5]
      end

      it 'parsed' do
        expect { ImportAccount.import parse two_debit_csv }.to \
          change(Debit, :count).by 2
      end
    end

    context 'debit with payment' do
      def debit_with_payment
        %q[122, GR, 2011-12-25 00:00:00, Ground Rent..., 47.5,    0, 47.5
           122, GR, 2012-01-11 15:32:00, Payment Gr....,    0, 47.5,    0]
      end

      it 'parsed' do
        expect { ImportAccount.import parse debit_with_payment }.to \
          change(Payment, :count).by 1
      end
    end

    context 'two debits with 1 payment' do
      def two_debits_1_payment
        %q[122, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           122, GR, 2012-12-25 00:00:00, Ground Rent..., 40.5,    0, 81.0
           122, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 40.5, 40.5]
      end

      it 'parsed' do
        expect { ImportAccount.import parse two_debits_1_payment  }.to \
          change(Credit, :count).by 1
        expect(Debit.all).to have(2).items
      end
    end

    context 'payment covering 2 debits' do

      def payment_covering_2_debits
        %q[122, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           122, GR, 2012-12-25 00:00:00, Ground Rent..., 40.5,    0, 81.0
           122, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 81.0,    0]
      end

      it '1 credit covering multiple debit' do
        expect { ImportAccount.import parse payment_covering_2_debits }.to \
          change(Credit, :count).by 2
        expect(Debit.all).to have(2).items
      end
    end

    context 'two properties' do

      def two_properties
        %q[122, GR, 2011-12-25 00:00:00, Ground Rent..., 40.5,    0, 40.5
           122, GR, 2012-01-11 15:32:00, Payment Grou..,    0, 40.5, 40.5
           123, GR, 2011-12-25 00:00:00, Ground Rent .., 30.5,    0, 30.5
           123, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 30.5, 30.5]
      end

      it '2 properties' do
        property_with_charge_create! human_ref: 123
        expect { ImportAccount.import parse two_properties }.to \
          change(Credit, :count).by 2
        expect(Debit.all).to have(2).items
        expect(Property.find_by!(human_ref: 122).account.credits).to have(1).items
        expect(Property.find_by!(human_ref: 123).account.credits).to have(1).items
      end
    end

    context 'One credit' do
      def one_credit_csv
        %q[122, GR, 2012-01-11 15:32:00, Payment Gro...,    0, 37.5,    0]
      end

      it 'One credit' do
        pending
        expect { ImportAccount.import parse one_credit_csv }.to \
          change(Credit, :count).by 1
      end
    end

    def parse row_string
      CSV.parse( row_string,
                 { headers: FileHeader.account,
                   header_converters: :symbol,
                   converters: lambda { |f| f ? f.strip : nil } }
               )
    end
  end
end
