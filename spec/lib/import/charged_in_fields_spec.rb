require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/charged_in_fields'

####
#
# charged_inf_fields_spec.rb
#
# unit testing for charged_in_fields
#
# ChargedInFields wraps up fields from acc_info.csv rows
# - used by ImportCharge - fed into ChargeRow which initializes
# ChargedInFields
#
####
module DB
  describe ChargedInFields, :import do
    describe '#id' do
      context 'valid legacy code' do
        it 'returns charged_in code' do
          charged = ChargedInFields.new charged_in_code: '0',
                                        charge_type: 'unknown'
          expect(charged.id).to eq 1
        end

        it 'returns charge_type code over charged_in_code' do
          charged = ChargedInFields.new charged_in_code: '0',
                                        charge_type: 'Insurance'
          expect(charged.id).to eq 2
        end
      end
      context 'invalid legacy code' do
        it 'errors when invalid code and unknown charge_type' do
          bad_charged = ChargedInFields.new charged_in_code: 'U',
                                            charge_type: 'unknown'
          expect { bad_charged.id }.to raise_error KeyError
        end

        it 'returns charge_type code over charged_in_code' do
          charged = ChargedInFields.new charged_in_code: 'U',
                                        charge_type: 'Insurance'
          expect(charged.id).to eq 2
        end
      end
    end
  end
end
