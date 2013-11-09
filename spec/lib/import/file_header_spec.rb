require 'spec_helper'
require_relative '../../../lib/import/file_header'

module DB
  describe FileHeader do

    it 'client' do
      fields =
        %w[
          human_ref
          title1  initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
        ]
      expect(FileHeader.client).to eq fields
    end

    it 'property' do
      fields =
        %w[
          human_ref  updated
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
          client_ref
        ]
      expect(FileHeader.property).to eq fields
    end

    it 'billing_profile' do
      fields =
        %w[
          human_ref
          title1 initials1 name1
          title2 initials2 name2
          flat_no house_name road_no road district town county postcode
        ]
      expect(FileHeader.billing_profile).to eq fields
    end

    it 'user' do
      fields = %w[email password admin]
      expect(FileHeader.user).to eq fields
    end
  end
end
