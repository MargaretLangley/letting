# rubocop: disable Metrics/LineLength
require 'rails_helper'

describe Notice, type: :model do

  describe 'validations' do
    it('returns valid') { expect(notice_new).to be_valid }
  end
end
