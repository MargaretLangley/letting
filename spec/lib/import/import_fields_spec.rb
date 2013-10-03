require 'spec_helper'
require_relative '../../../lib/import/import_fields'

module DB

  describe ImportFields do

   it 'client' do
      fields =
      %w[
        human_id
        title1  initials1 name1
        title2 initials2 name2
        flat_no house_name road_no road district town county postcode
      ]
      expect(ImportFields.client).to eq fields
   end

   it 'property' do
      fields =
      %w[
        human_id  updated
        title1 initials1 name1
        title2 initials2 name2
        flat_no house_name road_no road district town county postcode client_id
      ]
      expect(ImportFields.property).to eq fields
   end

   it 'billing_profile' do
      fields =
      %w[
        human_id
        title1 initials1 name1
        title2 initials2 name2
        flat_no house_name road_no road district town county postcode
      ]
      expect(ImportFields.billing_profile).to eq fields
   end

   it 'user' do
    fields = %w[email password admin]
    expect(ImportFields.user).to eq fields
   end

  end

end